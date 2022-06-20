import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tech_shop/widgets/sub_order_item.dart';

import '../models/cart.dart';

class SubordersList extends StatelessWidget {
  const SubordersList({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Cart> products;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: min(products.length * 50.0 + 50, 150),
      child: ListView.builder(
        itemBuilder: ((context, index) =>
            SuborderItem(product: products[index])),
        itemCount: products.length,
      ),
    );
  }
}
