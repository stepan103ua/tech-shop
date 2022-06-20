import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/screens/add_product_screen.dart';

class EditProductItem extends StatelessWidget {
  const EditProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: SizedBox(
                width: constraints.maxWidth * 0.15,
                child: Image.network(imageUrl)),
            title: SizedBox(
              width: constraints.maxWidth * 0.55,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            trailing: SizedBox(
              width: constraints.maxWidth * 0.3,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AddProductScreen.routeName, arguments: id),
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.showSnackBar(const SnackBar(
                          content: Text(
                        "Failed to delete the product",
                        textAlign: TextAlign.center,
                      )));
                    }
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).primaryColor,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
