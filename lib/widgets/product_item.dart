import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/auth_provider.dart';
import 'package:tech_shop/providers/cart_provider.dart';
import 'package:tech_shop/screens/product_detail_screen.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: false);
    var cartData = Provider.of<CartProvider>(context, listen: false);
    var authData = Provider.of<AuthProvider>(context, listen: false);
    var scaffold = Scaffold.of(context);
    return LayoutBuilder(
        builder: ((_, constraints) => GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: constraints.maxHeight,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    footer: GridTileBar(
                      title: Text(
                        product.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black87,
                      leading: Consumer<Product>(
                        builder: (consumerContext, value, child) => IconButton(
                          icon: Icon(product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            await product
                                .toggleFavorite(
                                    context, authData.userId!, authData.token!)
                                .catchError(
                                    (_) => scaffold.showSnackBar(const SnackBar(
                                            content: Text(
                                          'Failed to toggle favorite',
                                          textAlign: TextAlign.center,
                                        ))));
                          },
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          cartData.addItem(product.id, product.title,
                              product.imageUrl, product.price);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              '${product.title} added to cart',
                              textAlign: TextAlign.center,
                            ),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cartData.decreaseItemCount(product.id);
                              },
                            ),
                          ));
                        },
                      ),
                    ),
                    header: Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.05),
                        margin: EdgeInsets.all(constraints.maxHeight * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black87),
                        child: Text(
                          "\$ ${product.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )));
  }
}
