import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tech_shop/widgets/sub_order_item.dart';

import '../models/cart.dart';

class SubordersList extends StatelessWidget {
  const SubordersList({
    Key? key,
    required this.products,
    required this.expanded,
  }) : super(key: key);

  final List<Cart> products;
  final bool expanded;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: expanded ? min(products.length * 50.0 + 50, 500) : 0,
        child: ListView.builder(
          itemBuilder: ((context, index) =>
              SuborderItem(product: products[index])),
          itemCount: products.length,
        ),
      );
    });
  }
}
