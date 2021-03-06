import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/widgets/edit_product_item.dart';
import 'package:tech_shop/widgets/main_drawer.dart';

import 'add_product_screen.dart';

class ProductsEditingScreen extends StatelessWidget {
  const ProductsEditingScreen({Key? key}) : super(key: key);

  static const routeName = '/editing';

  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .loadProducts(context, all: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editing"),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddProductScreen.routeName),
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .loadProducts(context, all: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var productsList =
                Provider.of<ProductsProvider>(context, listen: false).products;
            return RefreshIndicator(
              onRefresh: () => _refreshScreen(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) => EditProductItem(
                    id: productsList[index].id,
                    title: productsList[index].title,
                    imageUrl: productsList[index].imageUrl,
                  ),
                  itemCount: productsList.length,
                ),
              ),
            );
          }

          return const Center(
            child: Text("Something went wrong..."),
          );
        },
      ),
    );
  }
}
