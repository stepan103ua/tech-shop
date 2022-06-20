import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/widgets/product_item.dart';

import '../providers/product.dart';

class ProductsList extends StatelessWidget {
  final bool showOnlyFavorites;
  const ProductsList({
    Key? key,
    required this.showOnlyFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<ProductsProvider>(context);
    var productsList = showOnlyFavorites
        ? productsData.favoriteProducts
        : productsData.products;
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          var product = productsList[index];
          return SizedBox(
            height: constraints.maxHeight * 0.4,
            width: double.infinity,
            child: ChangeNotifierProvider.value(
              value: product,
              child: ProductItem(),
            ),
          );
        },
        itemCount: productsList.length,
      ),
    );
  }
}
