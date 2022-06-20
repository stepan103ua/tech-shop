import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({Key? key, required this.icon}) : super(key: key);
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5),
          ],
        ),
        child: icon,
      ),
    );
  }
}
