import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/models/cart.dart';
import 'package:tech_shop/providers/cart_provider.dart';
import 'package:tech_shop/providers/order_provider.dart';
import 'package:tech_shop/widgets/appbar_icon_container.dart';
import 'package:tech_shop/widgets/cart_item.dart';

import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartProvider>(context);
    var cartItems = cartData.cartItems.values.toList();
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) => CartItem(
                    id: cartItems[index].id,
                    itemKey: cartData.cartItems.keys.toList()[index],
                    title: cartItems[index].title,
                    imageUrl: cartItems[index].imageUrl,
                    price: cartItems[index].pricePerProduct,
                    count: cartItems[index].count,
                  )),
              itemCount: cartItems.length,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Chip(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        label: Text(
                          '\$ ${cartData.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const Spacer(),
                      OrderButton(cartItems: cartItems, cartData: cartData),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
