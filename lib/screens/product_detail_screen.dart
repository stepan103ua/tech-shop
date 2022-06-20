import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/product.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/widgets/appbar_icon_container.dart';
import 'package:tech_shop/widgets/characteristic_detail_item.dart';
import 'package:tech_shop/widgets/lighted_container.dart';

import '../structures/pair.dart';
import '../widgets/description_container.dart';
import '../widgets/image_slider_detail.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static String routeName = '/product-detail';

  List<Widget> getCharacteristicsList(
      Map<dynamic, dynamic> characteristicsData, BoxConstraints constraints) {
    List<Widget> resultList = [];
    characteristicsData.forEach((title, value) {
      resultList.add(Container(
          padding: EdgeInsets.only(
            left: constraints.maxWidth * 0.03,
            right: constraints.maxWidth * 0.03,
            bottom: constraints.maxHeight * 0.02,
          ),
          child: Column(
            children: [
              CharacteristicDetailItem(data: Pair(title, value)),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              const Divider(
                thickness: 3,
              ),
            ],
          )));
    });
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    var loadedProduct = Provider.of<ProductsProvider>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          loadedProduct.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03),
            child: Column(
              children: [
                ImageSliderDetail(
                  loadedProduct: loadedProduct,
                  constraints: constraints,
                ),
                DescriptionContainer(
                    description: loadedProduct.description,
                    constraints: constraints),
                LightedContainer(
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Characteristics",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.03,
                      ),
                      ...getCharacteristicsList(
                          loadedProduct.characteristics, constraints)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
