import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tech_shop/structures/pair.dart';

class CharacteristicDetailItem extends StatelessWidget {
  const CharacteristicDetailItem({Key? key, required this.data})
      : super(key: key);
  final Pair data;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: (data.second as String).length > 35
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.4,
              child: Text(
                data.first,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Text(
                data.second,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
