class ProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final int mrp; // Maximum Retail Price
  final int slp; // Selling Price
  final int quantity;
  final String type;
  final int totalRatings;
  final double averageRating;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.mrp,
    required this.slp,
    required this.quantity,
    required this.type,
    this.totalRatings = 0,
    this.averageRating = 0.0,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      mrp: map['mrp'] ?? 0,
      slp: map['slp'] ?? 0,
      quantity: map['quantity'] ?? 0,
      type: map['type'] ?? '',
      totalRatings: map['totalRatings'] ?? 0,
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'mrp': mrp,
      'slp': slp,
      'quantity': quantity,
      'type': type,
      'totalRatings': totalRatings,
      'averageRating': averageRating,
    };
  }

  // Helper methods
  double get discountPercentage {
    if (mrp <= 0) return 0;
    return ((mrp - slp) / mrp) * 100;
  }

  bool get isInStock => quantity > 0;

  String get formattedMrp => 'AED ${mrp.toString()}';
  String get formattedSlp => 'AED ${slp.toString()}';

  // Rating helper methods
  bool get hasRatings => totalRatings > 0;
  String get formattedRating => averageRating.toStringAsFixed(1);
  String get ratingText =>
      hasRatings ? '$formattedRating ($totalRatings)' : 'No ratings';
}
