import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/auth_provider.dart';
import 'package:tech_shop/screens/orders_screen.dart';
import 'package:tech_shop/screens/products_editing_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Menu"),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("My Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Edit products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductsEditingScreen.routeName),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log out"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<AuthProvider>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
