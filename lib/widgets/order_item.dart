import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import 'sub_orders_list.dart';

class OrderItem extends StatefulWidget {
  final Order orderData;
  const OrderItem({Key? key, required this.orderData}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _expanded
            ? constraints.minHeight +
                min(widget.orderData.products.length * 50 + 50, 500)
            : constraints.minHeight,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: Text('\$ ${widget.orderData.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd.MM.yyyy hh:mm').format(widget.orderData.date)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            SubordersList(
              products: widget.orderData.products,
              expanded: _expanded,
            ),
          ]),
        ),
      ),
    );
  }
}
