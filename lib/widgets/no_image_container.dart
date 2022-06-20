import 'package:flutter/material.dart';

class NoImageContainer extends StatelessWidget {
  const NoImageContainer({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
