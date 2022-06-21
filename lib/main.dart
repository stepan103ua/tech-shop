import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/auth_provider.dart';
import 'package:tech_shop/providers/cart_provider.dart';
import 'package:tech_shop/providers/categories_provider.dart';
import 'package:tech_shop/providers/order_provider.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/screens/add_category_screen.dart';
import 'package:tech_shop/screens/add_product_screen.dart';
import 'package:tech_shop/screens/auth_screen.dart';
import 'package:tech_shop/screens/cart_screen.dart';
import 'package:tech_shop/screens/categories_screen.dart';
import 'package:tech_shop/screens/orders_screen.dart';
import 'package:tech_shop/screens/product_detail_screen.dart';
import 'package:tech_shop/screens/products_editing_screen.dart';
import 'package:tech_shop/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider([]),
          update: (context, auth, previous) => ProductsProvider(
            previous == null ? [] : previous.products,
            authToken: auth.token!,
          ),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (context) => OrderProvider([]),
          update: (context, auth, previous) => OrderProvider(
              previous == null ? [] : previous.orders,
              authToken: auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CategoriesProvider>(
          create: (context) => CategoriesProvider(''),
          update: (context, auth, previous) => CategoriesProvider(auth.token!),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontStyle: FontStyle.italic),
                foregroundColor: Colors.black,
                centerTitle: true,
                elevation: 2.0,
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepOrange),
              textTheme: const TextTheme(
                  titleLarge: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  titleMedium: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  titleSmall:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          home: auth.isAuthenticated ? const CategoriesScreen() : AuthScreen(),
          routes: {
            ProductOverviewScreen.routeName: (context) =>
                const ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CategoriesScreen.routeName: (context) => const CategoriesScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            ProductsEditingScreen.routeName: (context) =>
                const ProductsEditingScreen(),
            AddProductScreen.routeName: (context) => const AddProductScreen(),
            AddCategoryScreen.routeName: (context) => const AddCategoryScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
