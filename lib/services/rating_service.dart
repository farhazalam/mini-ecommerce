import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Submit a rating for a product
  static Future<void> submitRating({
    required String productId,
    required int rating, // 1-5 stars
    String? review,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      final ratingData = {
        'productId': productId,
        'userId': user.uid,
        'rating': rating,
        'review': review ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save rating to ratings collection
      await _firestore.collection('ratings').add(ratingData);

      // Update product rating statistics
      await _updateProductRatings(productId);

      print('Rating submitted successfully for product: $productId');
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }

  /// Update product rating statistics
  static Future<void> _updateProductRatings(String productId) async {
    try {
      // Get all ratings for this product
      final ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .get();

      if (ratingsSnapshot.docs.isEmpty) {
        return;
      }

      // Calculate average rating and total count
      double totalRating = 0;
      int ratingCount = 0;

      for (var doc in ratingsSnapshot.docs) {
        final data = doc.data();
        totalRating += (data['rating'] as int).toDouble();
        ratingCount++;
      }

      final averageRating = totalRating / ratingCount;

      // Update product document with new rating statistics
      await _firestore.collection('products').doc(productId).update({
        'totalRatings': ratingCount,
        'averageRating': averageRating,
      });

      print(
        'Product ratings updated: $ratingCount ratings, $averageRating average',
      );
    } catch (e) {
      print('Error updating product ratings: $e');
      throw Exception('Failed to update product ratings: $e');
    }
  }

  /// Get ratings for a specific product
  static Future<List<Map<String, dynamic>>> getProductRatings(
    String productId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get product ratings: $e');
    }
  }

  /// Check if user has already rated a product
  static Future<bool> hasUserRated(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final snapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user has rated: $e');
      return false;
    }
  }

  /// Get user's rating for a specific product
  static Future<int?> getUserRating(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final snapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['rating'] as int;
      }
      return null;
    } catch (e) {
      print('Error getting user rating: $e');
      return null;
    }
  }

  /// Delete a user's rating for a product
  static Future<void> deleteRating(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Find and delete the rating
      final snapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();

        // Update product rating statistics
        await _updateProductRatings(productId);
      }
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }
}
