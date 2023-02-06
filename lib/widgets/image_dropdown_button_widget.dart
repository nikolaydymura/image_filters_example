import 'package:flutter/material.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../models/external_image_texture.dart';

class ImageDropdownButtonWidget<T extends ExternalImageTexture>
    extends StatelessWidget {
  final AdditionalSourceImageState<T> state;
  final void Function(T) onChanged;

  const ImageDropdownButtonWidget({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<T>(
        value: state.selected,
        icon: const Icon(Icons.photo_filter),
        elevation: 8,
        style: TextStyle(color: Theme.of(context).primaryColor),
        underline: Container(
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (T? value) {
          if (value != null) {
            onChanged.call(value);
          }
        },
        items: state.items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (value is AssetExternalImageTexture)
                    Image.asset(value.asset),
                  if (value is FileExternalImageTexture) Image.file(value.file),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      value.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
