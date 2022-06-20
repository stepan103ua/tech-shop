import 'dart:convert';

class Cart {
  final String id;
  final String title;
  final String imageUrl;
  int count = 1;
  final double pricePerProduct;

  Cart({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.pricePerProduct,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'count': count,
      'pricePerProduct': pricePerProduct,
    };
  }
}
