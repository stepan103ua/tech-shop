import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/models/category.dart';
import 'package:tech_shop/providers/categories_provider.dart';
import 'package:tech_shop/widgets/preview_image_container.dart';

import '../widgets/image_url_text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = '/add-category';
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  String? title;
  String? imageUrl;
  Future<void> save() async {
    setState(() {
      isLoading = true;
    });

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    imageUrl = _imageUrlController.text;
    await Provider.of<CategoriesProvider>(context, listen: false)
        .addCategory(Category(title: title!, imageUrl: imageUrl!));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adding a new category')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Category title'),
                          onSaved: (text) {
                            text == null ? '' : title = text;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ImageUrlTextField(
                            imageUrlController: _imageUrlController),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              save();
                            },
                            child: const Text('Save'))
                      ],
                    )),
              ),
            ),
    );
  }
}
