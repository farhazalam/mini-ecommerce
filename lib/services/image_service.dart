import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../config/app_config.dart';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery or camera
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      // Let image_picker handle permissions automatically
      // It will show the system permission dialog when needed
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      // Handle specific permission errors
      String errorMessage = e.toString();

      // More specific error handling for iOS
      if (errorMessage.contains('camera') || errorMessage.contains('Camera')) {
        throw Exception('camera permission denied');
      } else if (errorMessage.contains('photo') ||
          errorMessage.contains('gallery') ||
          errorMessage.contains('library') ||
          errorMessage.contains('Photos') ||
          errorMessage.contains('PHPhotoLibrary')) {
        throw Exception('photo library permission denied');
      } else if (errorMessage.contains('permission') ||
          errorMessage.contains('Permission')) {
        // Generic permission error - determine based on source
        if (source == ImageSource.camera) {
          throw Exception('camera permission denied');
        } else {
          throw Exception('photo library permission denied');
        }
      } else {
        throw Exception('Error picking image: $e');
      }
    }
  }

  // Crop the selected image
  static Future<File?> cropImage(String imagePath) async {
    if (!AppConfig.enableImageCropper) {
      // If cropping is disabled, return the original image
      return File(imagePath);
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Profile Picture'),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error cropping image: $e');
    }
  }

  // Upload image to Firebase Storage
  static Future<String> uploadProfileImage(File imageFile) async {
    if (!AppConfig.enableFirebaseStorage) {
      throw Exception(AppConfig.storageDisabledMessage);
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create a unique filename
      final fileName =
          'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('profile_images/$fileName');

      // Upload the file
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Update user profile with new image URL
  static Future<void> updateUserProfileImage(String imageUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Delete old profile image from storage
  static Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {}
  }

  // Complete flow: pick, crop, upload, and update profile
  static Future<String?> pickCropAndUploadProfileImage() async {
    try {
      // Pick image
      final imageFile = await pickImage();
      if (imageFile == null) return null;

      // Crop image
      final croppedFile = await cropImage(imageFile.path);
      if (croppedFile == null) return null;

      // Check if storage is enabled
      if (!AppConfig.enableFirebaseStorage) {
        throw Exception(AppConfig.storageDisabledMessage);
      }

      // Upload image
      final imageUrl = await uploadProfileImage(croppedFile);

      // Update user profile
      await updateUserProfileImage(imageUrl);

      return imageUrl;
    } catch (e) {
      throw Exception('Error processing profile image: $e');
    }
  }
}
