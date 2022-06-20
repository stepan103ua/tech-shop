import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/cart_provider.dart';
import 'package:tech_shop/widgets/cart_counter.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String itemKey;
  final String title;
  final String imageUrl;
  final double price;
  final int count;
  const CartItem({
    Key? key,
    required this.title,
    required this.price,
    required this.count,
    required this.id,
    required this.itemKey,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Dismissible(
        onDismissed: (direction) =>
            Provider.of<CartProvider>(context, listen: false)
                .removeItem(itemKey),
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        confirmDismiss: (direction) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text(
                    "Remove product from cart",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "Are you sure to remove $title from cart?",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No")),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes")),
                  ],
                )),
        child: Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: SizedBox(
                width: constraints.maxWidth * 0.1,
                child: Image.network(imageUrl)),
            title: SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Center(
              child: CartCounter(
                id: itemKey,
              ),
            ),
            trailing: SizedBox(
              width: constraints.maxWidth * 0.25,
              child: Text(
                '\$ ${(price * count).toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
