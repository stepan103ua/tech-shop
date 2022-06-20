import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/cart_provider.dart';

class CartCounter extends StatelessWidget {
  final String id;
  const CartCounter({Key? key, required this.id}) : super(key: key);

  Widget _buildIconContainer(BuildContext context, IconButton iconButton) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: iconButton);
  }

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartProvider>(context, listen: false);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconContainer(
              context,
              IconButton(
                  onPressed: () => cartData.decreaseItemCount(id),
                  icon: const Icon(
                    Icons.remove,
                  ))),
          Text(
            '${cartData.cartItems[id]!.count}x',
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildIconContainer(
              context,
              IconButton(
                  onPressed: () => cartData.increaseItemCount(id),
                  icon: const Icon(Icons.add))),
        ],
      ),
    );
  }
}
