import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartItems,
    required this.cartData,
  }) : super(key: key);

  final List<Cart> cartItems;
  final CartProvider cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cartData.totalAmount <= 0.0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(
                            widget.cartItems, widget.cartData.totalAmount);
                    _isLoading = false;
                    widget.cartData.clear();
                  },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
            ),
            child: const Text(
              "Order now",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ));
  }
}
