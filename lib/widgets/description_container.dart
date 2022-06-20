import 'package:flutter/material.dart';

import '../providers/product.dart';
import 'lighted_container.dart';

class DescriptionContainer extends StatelessWidget {
  const DescriptionContainer({
    Key? key,
    required this.description,
    required this.constraints,
  }) : super(key: key);

  final String description;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return LightedContainer(
        margin: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.05,
            vertical: constraints.maxHeight * 0.03),
        child: Column(
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.03,
            ),
            Container(
                width: constraints.maxWidth,
                margin: EdgeInsets.only(
                    bottom: constraints.maxHeight * 0.03,
                    left: constraints.maxWidth * 0.03,
                    right: constraints.maxWidth * 0.03),
                child: Text(
                  description,
                  textAlign: description.length > 30
                      ? TextAlign.start
                      : TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                )),
          ],
        ));
  }
}
