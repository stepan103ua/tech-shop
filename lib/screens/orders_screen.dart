import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/order_provider.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/widgets/main_drawer.dart';
import 'package:tech_shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ordersData = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case ConnectionState.done:
              return Consumer<OrderProvider>(
                builder: (context, value, child) => ListView.builder(
                  itemBuilder: (context, index) =>
                      OrderItem(orderData: ordersData.orders[index]),
                  itemCount: ordersData.orders.length,
                ),
              );
            default:
              return Center(
                child: Text(
                  "Something went wrong...",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
          }
        },
      ),
    );
  }
}
