import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/models/http_exception.dart';
import 'package:tech_shop/models/unauthorized_exception.dart';
import 'package:tech_shop/providers/auth_provider.dart';
import 'package:tech_shop/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;

  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  ProductsProvider(
    this._products, {
    this.authToken,
  });

  String? categotyId;

  Future<void> loadProducts(BuildContext context, {bool? all}) async {
    print('1');
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;

    final url = categotyId == null || (all != null && all)
        ? 'https://tech-shop-6ad94-default-rtdb.firebaseio.com/products.json?auth=$authToken'
        : 'https://tech-shop-6ad94-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="categoryId"&equalTo="$categotyId"';
    final favoritesUrl =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/favorites.json?auth=$authToken';
    print('2');

    final response = await get(Uri.parse(url));
    print('3');
    final favoritesResponse = await get(Uri.parse(favoritesUrl));
    print('4');

    final data = json.decode(response.body) as Map<String, dynamic>?;
    final favoriteData = json.decode(favoritesResponse.body);
    print('5');
    if (response.statusCode == 401) {
      throw UnauthorizedException('Not authentificated');
    }
    if (data == null) {
      print('data is null');
      return;
    }
    print('6');

    final List<Product> loadedProducts = [];

    data.forEach((productId, productData) {
      loadedProducts.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        characteristics: productData['characteristics'],
      ));
      loadedProducts.last.isFavorite = favoriteData == null ||
              favoriteData[userId] == null ||
              favoriteData[userId][productId] == null
          ? false
          : favoriteData[userId][productId];
    });
    _products = loadedProducts;
    print('7');
    print(_products);
    notifyListeners();
  }

  List<Product> get favoriteProducts {
    return _products
        .where(
          (product) => product.isFavorite,
        )
        .toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final response = await post(Uri.parse(url), body: product.getJson());

    product = product.copyWith(id: json.decode(response.body)['name']);
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _products.indexWhere((product) => product.id == id);
    if (productIndex < 0) return;
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final response = await patch(Uri.parse(url), body: newProduct.getJson());
    if (response.statusCode >= 400) {
      throw HttpException(
          'Product is not updated ( Status code: ${response.statusCode} ).');
    }

    _products[productIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final productIndex = _products.indexWhere((product) => product.id == id);
    Product? temporaryProduct = _products[productIndex];

    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    _products.removeAt(productIndex);
    notifyListeners();
    final response = await delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _products.insert(productIndex, temporaryProduct);
      notifyListeners();
      throw HttpException(
          "Product is not deleted ( Status code: ${response.statusCode} ).");
    }
    temporaryProduct = null;
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }
}
