import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class Badge extends StatelessWidget {
  final Widget child;

  const Badge({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartCount = Provider.of<CartProvider>(context).itemCount;
    return Center(
      child: Stack(
        children: [
          child,
          cartCount == 0
              ? Container()
              : Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 10,
                    child: Consumer<CartProvider>(
                      builder: (context, value, child) => FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
