import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products
  Stream<List<ProductModel>> getAllProducts() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get products by type/category
  Stream<List<ProductModel>> getProductsByType(String type) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Search products by name
  Stream<List<ProductModel>> searchProducts(String query) {
    if (query.isEmpty) {
      return getAllProducts();
    }

    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.description.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    product.type.toLowerCase().contains(query.toLowerCase()),
              )
              .toList(),
        );
  }

  // Get single product by ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return ProductModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching product: $e';
    }
  }

  // Get available product types
  Stream<List<String>> getProductTypes() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data()['type'] as String? ?? '')
              .where((type) => type.isNotEmpty)
              .toSet()
              .toList(),
        );
  }

  // Get products with pagination
  Future<List<ProductModel>> getProductsWithPagination({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore.collection(_collection).limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => ProductModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw 'Error fetching products: $e';
    }
  }
}
