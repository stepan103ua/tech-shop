import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/providers/categories_provider.dart';
import 'package:tech_shop/providers/product.dart';
import 'package:tech_shop/providers/products_provider.dart';
import 'package:tech_shop/widgets/appbar_icon_container.dart';
import 'package:tech_shop/widgets/loading.dart';

import '../structures/pair.dart';
import '../widgets/characteristics_form.dart';
import '../widgets/no_image_container.dart';
import '../widgets/preview_image_container.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  static const routeName = '/add-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _mainForm = GlobalKey<FormState>();
  final _characteristicsForm = GlobalKey<FormState>();
  final List<Pair> characteristicsPairList = [];
  String? categoryTitle = 'Category';
  String? selectedCategory;
  var _isEditing = false;
  var _isLoading = false;
  var _initialProductValues = {};
  var _isInitialized = false;
  var characteristics = {};
  var characteristicsKeys = [];
  var product = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    categoryId: '',
  );

  var characteristicsAmount = 0;

  void _updateImageFocusNode() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageFocusNode);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      var productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        product = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initialProductValues = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'isFavorite': product.isFavorite,
        };
        if (product.categoryId != null) {
          categoryTitle =
              Provider.of<CategoriesProvider>(context, listen: false)
                  .findById(product.categoryId!)
                  .title;
        }
        characteristics = product.characteristics;
        _imageUrlController.text = product.imageUrl;
        characteristicsAmount = characteristics.length;
        _isEditing = true;
        characteristics.forEach(
            (key, value) => characteristicsPairList.add(Pair(key, value)));
      }
    }
    _isInitialized = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageFocusNode.removeListener(_updateImageFocusNode);
    _imageFocusNode.dispose();
    super.dispose();
  }

  bool _saveMainForm() {
    if (!_mainForm.currentState!.validate()) return false;
    if (product.id != '') {
      _mainForm.currentState!.save();
      product.isFavorite = _initialProductValues['isFavorite'];
      return true;
    }
    _mainForm.currentState!.save();
    return true;
  }

  bool _saveCharacteristicsForm() {
    if (!_characteristicsForm.currentState!.validate()) return false;
    _characteristicsForm.currentState!.save();
    return true;
  }

  Future<void> _save(
      BuildContext context, ProductsProvider productsProvider) async {
    if (!_saveMainForm() || !_saveCharacteristicsForm()) return;
    characteristics.clear();
    characteristicsPairList.forEach((pair) {
      if (pair.first != null && pair.second != null) {
        characteristics.putIfAbsent(pair.first, () => pair.second);
      }
    });

    product.characteristics = characteristics;
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isEditing) {
        await productsProvider.updateProduct(product.id, product);
      } else {
        await productsProvider.addProduct(product);
      }
    } catch (error) {
      await _showErrorDialog(context);
    } finally {
      Navigator.of(context).pop();
    }
  }

  void _deleteItem(String? key) {
    if (key != null) {
      setState(() {
        characteristicsPairList.removeWhere((element) => element.first == key);
      });

      print(characteristicsPairList);
    }
  }

  Future<dynamic> _showErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(
                'Error',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: const Text(
                "Something went wrong on saving product to server...",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text("Close"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var _productsData = Provider.of<ProductsProvider>(context, listen: false);
    var _categoriesData =
        Provider.of<CategoriesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new product"),
        leading: const BackIconButton(icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () => _save(context, _productsData),
              icon: const Icon(Icons.check))
        ],
      ),
      body: _isLoading
          ? const Loading(text: "Saving the product...")
          : LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Text(
                      "Main information",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      //height: 500,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                          key: _mainForm,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: _initialProductValues['title'],
                                decoration:
                                    const InputDecoration(labelText: "Title"),
                                textInputAction: TextInputAction.next,
                                validator: (text) {
                                  if (text!.isEmpty)
                                    return 'Title can not be empty';
                                  if (text.length <= 3) {
                                    return 'Title must be longer then 4 or more characters';
                                  }

                                  return null;
                                },
                                onSaved: (titleText) => product = Product(
                                  id: product.id,
                                  title: titleText!,
                                  description: product.description,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                  categoryId: product.categoryId,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: _initialProductValues['price'],
                                decoration:
                                    const InputDecoration(labelText: "Price"),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validator: (price) {
                                  if (price!.isEmpty)
                                    return 'Price can not be empty';
                                  if (double.tryParse(
                                          price.replaceFirst(',', '.')) ==
                                      null) {
                                    return 'Price must be a number';
                                  }
                                  if (double.parse(
                                          price.replaceFirst(',', '.')) <
                                      0) {
                                    return 'Price can not be negative';
                                  }

                                  return null;
                                },
                                onSaved: (priceText) => product = Product(
                                    id: product.id,
                                    title: product.title,
                                    description: product.description,
                                    price: double.parse(
                                        priceText!.replaceFirst(',', '.')),
                                    imageUrl: product.imageUrl,
                                    categoryId: product.categoryId),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue:
                                    _initialProductValues['description'],
                                decoration: const InputDecoration(
                                    labelText: "Description"),
                                maxLines: 4,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                validator: (text) {
                                  if (text!.isEmpty)
                                    return 'Description can not be empty';

                                  return null;
                                },
                                onSaved: (descriptionText) => product = Product(
                                    id: product.id,
                                    title: product.title,
                                    description: descriptionText!,
                                    price: product.price,
                                    imageUrl: product.imageUrl,
                                    categoryId: product.categoryId),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DropdownButtonFormField<String>(
                                  value: selectedCategory,
                                  decoration: InputDecoration(
                                    hintText: categoryTitle,
                                    labelText: selectedCategory != null
                                        ? 'Category'
                                        : null,
                                  ),
                                  validator: (category) {
                                    if (category == null &&
                                        categoryTitle == 'Category') {
                                      return 'Select category';
                                    }
                                    return null;
                                  },
                                  onChanged: ((newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  }),
                                  onSaved: (category) {
                                    product =
                                        product.copyWith(categoryId: category);
                                  },
                                  items: _categoriesData.categories
                                      .map((category) {
                                    return DropdownMenuItem<String>(
                                        value: category.id,
                                        child: Text(category.title));
                                  }).toList()),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  PreviewImageContainer(
                                      imageUrl: _imageUrlController.text),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: "Image URL"),
                                      controller: _imageUrlController,
                                      //onFieldSubmitted: (text) => setState(() {}),
                                      focusNode: _imageFocusNode,
                                      validator: (url) {
                                        if (url!.isEmpty)
                                          return 'Url can not be empty';
                                        if (!url.endsWith('.png') &&
                                            !url.endsWith('.jpg') &&
                                            !url.endsWith('.jpeg')) {
                                          return 'Invalid image url';
                                        }

                                        return null;
                                      },
                                      //onEditingComplete: () => _saveMainForm(),
                                      onSaved: (urlText) {
                                        product = Product(
                                            id: product.id,
                                            title: product.title,
                                            description: product.description,
                                            price: product.price,
                                            imageUrl: urlText!,
                                            categoryId: product.categoryId);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    CharacteristicsForm(
                      onDelete: _deleteItem,
                      characteristicsPairList: characteristicsPairList,
                      characteristicsForm: _characteristicsForm,
                      characteristics: characteristics,
                      characteristicsAmount: characteristicsAmount,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
