import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/cart.dart';

class SuborderItem extends StatelessWidget {
  final Cart product;
  const SuborderItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.imageUrl,
        height: 50.0,
        width: 50,
      ),
      title: Text(
        product.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text('${product.count}x'),
      trailing: Text(
        '\$ ${(product.pricePerProduct * product.count).toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
