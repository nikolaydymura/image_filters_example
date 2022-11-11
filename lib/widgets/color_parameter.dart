import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_filters/image_filters.dart';

class ColorParameterWidget extends StatelessWidget {
  final ColorParameter parameter;
  final VoidCallback onChanged;

  const ColorParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: parameter.value.toString()),
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: parameter.value, //default color
                      onColorChanged: (Color color) {
                        //on color picked
                        parameter.value = color;
                        onChanged.call();
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('DONE'),
                      onPressed: () {
                        Navigator.of(context).pop(); //dismiss the color picker
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.color_lens_outlined),
        )
      ],
    );
  }
}
