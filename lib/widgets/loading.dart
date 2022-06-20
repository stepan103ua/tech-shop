import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.1,
            ),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
