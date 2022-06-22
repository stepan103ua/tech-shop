import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../models/cart.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  String? userId;

  OrderProvider(this._orders, {this.authToken, this.userId});

  List<Order> get orders => [..._orders];

  final String? authToken;

  Future<void> loadOrders() async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await get(Uri.parse(url));

    List<Order> orders = [];
    final loadedData = json.decode(response.body) as Map<String, dynamic>?;
    if (loadedData == null) return;
    loadedData.forEach((orderId, orderData) {
      orders.insert(
          0,
          Order(
              id: orderId,
              amount: orderData['amount'],
              products:
                  (orderData['products'] as List<dynamic>).map((cartItemData) {
                var newCart = Cart(
                    imageUrl: cartItemData['imageUrl'],
                    id: cartItemData['id'],
                    title: cartItemData['title'],
                    pricePerProduct: cartItemData['pricePerProduct']);
                newCart.count = cartItemData['count'];
                return newCart;
              }).toList(),
              date: DateTime.parse(orderData['date'])));
    });
    _orders = orders;
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cartItems, double totalAmount) async {
    final url =
        'https://tech-shop-6ad94-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    var newOrder = Order(
      id: DateTime.now().toUtc().toString(),
      amount: totalAmount,
      products: cartItems,
      date: DateTime.now(),
    );
    final response = await post(Uri.parse(url), body: newOrder.jsonData);
    final firebaseId = json.decode(response.body)['name'];
    newOrder = newOrder.copyWith(id: firebaseId);
    _orders.insert(
      0,
      newOrder,
    );
    notifyListeners();
  }
}
