import 'package:flutter/material.dart';

import 'no_image_container.dart';

class PreviewImageContainer extends StatelessWidget {
  final String imageUrl;

  const PreviewImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: imageUrl.isEmpty
          ? NoImageContainer(
              text: "No image", color: Theme.of(context).primaryColor)
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const NoImageContainer(
                    text: "Wrong URL", color: Colors.red);
              },
            ),
    );
  }
}
