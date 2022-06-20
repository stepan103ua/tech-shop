import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/models/unauthorized_exception.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/screens/auth_screen.dart';
import 'package:tech_shop/screens/cart_screen.dart';
import 'package:tech_shop/widgets/badge.dart';
import 'package:tech_shop/widgets/main_drawer.dart';
import '../widgets/products_list.dart';

enum FiltersOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductsProvider>(context, listen: false);
    var appBar = AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: Text(
        "Tech Shop",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontStyle: FontStyle.italic),
      ),
      elevation: 2.0,
      actions: [
        Badge(
            child: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
        )),
        PopupMenuButton(
          onSelected: (value) {
            setState(() {
              switch (value) {
                case FiltersOptions.all:
                  _showOnlyFavorites = false;
                  break;
                case FiltersOptions.favorites:
                  _showOnlyFavorites = true;
                  break;
              }
            });
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: FiltersOptions.favorites,
              child: Text("Show only favorites"),
            ),
            const PopupMenuItem(
              value: FiltersOptions.all,
              child: Text("Show All"),
            ),
          ],
        ),
      ],
    );
    var height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .loadProducts(context)
            .catchError((error) {
          if (error is UnauthorizedException) {
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          }
        }),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case ConnectionState.done:
              return SizedBox(
                height: height,
                width: double.infinity,
                child: ProductsList(
                  showOnlyFavorites: _showOnlyFavorites,
                ),
              );
            default:
              return Center(
                  child: Text(
                "Something went wrong...",
                style: Theme.of(context).textTheme.titleMedium,
              ));
          }
        },
      ),
    );
  }
}
