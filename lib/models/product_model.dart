class ProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final int mrp; // Maximum Retail Price
  final int slp; // Selling Price
  final int quantity;
  final String type;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.mrp,
    required this.slp,
    required this.quantity,
    required this.type,
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
}
