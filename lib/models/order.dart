import 'dart:convert';

import 'cart.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime date;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });

  String get jsonData {
    return json.encode({
      'amount': amount,
      'date': date.toIso8601String(),
      'products': products.map((product) => product.toMap()).toList(),
    });
  }

  Order copyWith(
      {String? id, double? amount, List<Cart>? products, DateTime? date}) {
    return Order(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        products: products ?? this.products,
        date: date ?? this.date);
  }
}
