import 'package:flutter/material.dart';
import 'package:tech_shop/structures/pair.dart';

import '../providers/product.dart';

class CharacteristicsForm extends StatefulWidget {
  CharacteristicsForm({
    Key? key,
    required GlobalKey<FormState> characteristicsForm,
    required this.characteristics,
    required this.characteristicsAmount,
    required this.onDelete,
    required this.characteristicsPairList,
  })  : _characteristicsForm = characteristicsForm,
        super(key: key) {
    characteristicsKeys = characteristics.keys.toList();
    characteristicsValues = characteristics.values.toList();
  }
  final Function onDelete;
  final GlobalKey<FormState> _characteristicsForm;
  final Map<dynamic, dynamic> characteristics;
  final List<Pair> characteristicsPairList;
  late List<dynamic> characteristicsKeys;
  late List<dynamic> characteristicsValues;
  int characteristicsAmount;

  @override
  State<CharacteristicsForm> createState() => _CharacteristicsFormState();
}

class _CharacteristicsFormState extends State<CharacteristicsForm> {
  @override
  Widget build(BuildContext context) {
    print('char built');
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Сharacteristics",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (widget.characteristicsPairList.isNotEmpty)
                IconButton(
                    onPressed: () => setState(() {
                          widget.characteristicsPairList.removeLast();
                        }),
                    icon: const Icon(Icons.remove)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.characteristicsPairList.add(Pair(null, null));
                    });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
        Container(
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: widget._characteristicsForm,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CharacteristicsFormItem(
                  onDelete: widget.onDelete,
                  pairs: widget.characteristicsPairList,
                  characteristics: widget.characteristics,
                  characteristicData: widget.characteristicsPairList[index],
                );
              },
              itemCount: widget.characteristicsPairList.length,
            ),
          ),
        ),
      ],
    );
  }
}

class CharacteristicsFormItem extends StatelessWidget {
  CharacteristicsFormItem({
    Key? key,
    required this.characteristics,
    required this.onDelete,
    required this.pairs,
    required this.characteristicData,
  }) : super(key: key);

  final Map<dynamic, dynamic> characteristics;
  final List<Pair> pairs;

  final Pair characteristicData;
  final Function onDelete;
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();

  String? characteristicKey;

  @override
  Widget build(BuildContext context) {
    if (characteristicData.first != null) {
      _titleController.text = characteristicData.first!;
    }
    if (characteristicData.second != null) {
      _valueController.text = characteristicData.second!;
    }
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _titleController,
                  decoration: const InputDecoration(
                      hintText: 'Title', border: InputBorder.none),
                  validator: (title) {
                    if (title!.isEmpty) {
                      return 'Title can not be empty';
                    }
                    return null;
                  },
                  onSaved: (title) {
                    characteristicData.first = title;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  onDelete(characteristicData.first);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Divider(
            thickness: 3,
            color: Theme.of(context).primaryColor,
          ),
          TextFormField(
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            controller: _valueController,
            decoration: const InputDecoration(
                hintText: 'Information',
                border: InputBorder.none,
                labelStyle: TextStyle(fontWeight: FontWeight.normal)),
            validator: (info) {
              if (info!.isEmpty) {
                return 'Information can not be empty';
              }
              return null;
            },
            onSaved: (info) {
              characteristicData.second = info;
            },
          ),
        ],
      ),
    );
  }
}
