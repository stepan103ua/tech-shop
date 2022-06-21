import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/categories_provider.dart';
import 'package:tech_shop/screens/add_category_screen.dart';
import 'package:tech_shop/widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddCategoryScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<CategoriesProvider>(context, listen: false)
            .loadCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final categories =
                Provider.of<CategoriesProvider>(context).categories;
            return LayoutBuilder(
                builder: (context, constraints) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: constraints.maxWidth * 0.5,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15),
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            id: categories[index].id,
                            title: categories[index].title,
                            imageUrl: categories[index].imageUrl,
                          );
                        },
                        itemCount: categories.length,
                      ),
                    ));
          }

          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
