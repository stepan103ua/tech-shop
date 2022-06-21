import 'package:flutter/material.dart';
import 'package:tech_shop/widgets/preview_image_container.dart';

class ImageUrlTextField extends StatefulWidget {
  const ImageUrlTextField({
    Key? key,
    required TextEditingController imageUrlController,
  })  : _imageUrlController = imageUrlController,
        super(key: key);

  final TextEditingController _imageUrlController;

  @override
  State<ImageUrlTextField> createState() => _ImageUrlTextFieldState();
}

class _ImageUrlTextFieldState extends State<ImageUrlTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PreviewImageContainer(imageUrl: widget._imageUrlController.text),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextFormField(
            minLines: 1,
            maxLines: 10,
            controller: widget._imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
            validator: (text) {
              if (text!.isEmpty) {
                return 'Image URL can not be empty';
              }
            },
            onSaved: (text) => print(text),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}
