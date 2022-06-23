import 'package:flutter/material.dart';
import 'package:tech_shop/widgets/lighted_container.dart';

import '../providers/product.dart';

class ImageSliderDetail extends StatelessWidget {
  const ImageSliderDetail({
    Key? key,
    required this.loadedProduct,
    required this.constraints,
  }) : super(key: key);

  final Product loadedProduct;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: loadedProduct.id,
      child: LightedContainer(
          margin: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
