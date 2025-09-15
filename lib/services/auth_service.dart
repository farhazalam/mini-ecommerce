import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user?.updateDisplayName(fullName);

      await _firestore.collection('users').doc(result.user?.uid).set({
        'uid': result.user?.uid,
        'email': email,
        'fullName': fullName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return result;
    } on FirebaseAuthException catch (e) {
      throw _getAuthExceptionMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _getAuthExceptionMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential result = await _auth.signInWithCredential(credential);

      // Check if this is a new user
      if (result.additionalUserInfo?.isNewUser == true) {
        // Create user document in Firestore for new users
        await _firestore.collection('users').doc(result.user?.uid).set({
          'uid': result.user?.uid,
          'email': result.user?.email,
          'fullName': result.user?.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _getAuthExceptionMessage(e);
    } catch (e) {
      throw 'Google Sign-In failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Error fetching user data. Please try again.';
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    String? fullName,
    String? email,
  }) async {
    try {
      Map<String, dynamic> updateData = {};

      if (fullName != null) {
        updateData['fullName'] = fullName;
        await _auth.currentUser?.updateDisplayName(fullName);
      }

      if (email != null) {
        // Check if email is different from current email
        final currentUser = _auth.currentUser;
        if (currentUser?.email != email) {
          // For now, just update the Firestore document
          // Note: Firebase requires email verification for email changes
          // This is a limitation - the user will need to sign out and sign in with new email
          updateData['email'] = email;
          updateData['emailVerified'] = false;
        }
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
      }
    } catch (e) {
      throw 'Error updating profile. Please try again.';
    }
  }

  String _getAuthExceptionMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address. Please enter a valid email.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
