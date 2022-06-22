import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  var characteristics = {};
  final double price;
  final String imageUrl;
  String? categoryId;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.categoryId,
    characteristics,
  }) {
    if (characteristics != null) {
      this.characteristics = characteristics;
    }
  }

  Future<void> toggleFavorite(
      BuildContext context, String userId, String token) async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/favorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    Provider.of<ProductsProvider>(context, listen: false).notifyListeners();
    notifyListeners();
    try {
      await put(Uri.parse(url), body: json.encode(isFavorite));
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      rethrow;
    }
  }

  String getJson() {
    return json.encode({
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'characteristics': characteristics,
      if (categoryId != null) 'categoryId': categoryId
    });
  }

  Product copyWith({
    String? title,
    String? id,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    Map<dynamic, dynamic>? characteristics,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      characteristics: characteristics ?? this.characteristics,
    );
  }
}
