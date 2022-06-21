import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:tech_shop/models/category.dart' as shop;

class CategoriesProvider with ChangeNotifier {
  List<shop.Category> _categories = [];

  CategoriesProvider(this._token);

  List<shop.Category> get categories => [..._categories];

  final String _token;

  Future<void> loadCategories() async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/categories.json?auth=$_token';
    final response = await get(Uri.parse(url));
    final responseData = json.decode(response.body) as Map<String, dynamic>?;
    if (responseData == null) return;

    List<shop.Category> loadedCategories = [];
    responseData.forEach((categoryId, categoryData) {
      loadedCategories.add(shop.Category(
        id: categoryId,
        title: categoryData['title'],
        imageUrl: categoryData['imageUrl'],
      ));
    });
    _categories = loadedCategories;
  }

  Future<void> addCategory(shop.Category newCategory) async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/categories.json?auth=$_token';
    final response = await post(Uri.parse(url),
        body: json.encode({
          'title': newCategory.title,
          'imageUrl': newCategory.imageUrl,
        }));
    final categoryId = json.decode(response.body)['name'];
    if (categoryId == null) return;
    newCategory = newCategory.copyWith(id: categoryId);

    _categories.add(newCategory);
    notifyListeners();
  }
}
