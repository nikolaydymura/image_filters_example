import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class ColorParameterWidget extends StatelessWidget {
  final ColorParameter parameter;
  final VoidCallback onChanged;

  const ColorParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 24, 120),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              parameter.displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            color: parameter.value,
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          color: parameter.value, //default color
                          wheelDiameter: MediaQuery.sizeOf(context).width * 0.7,
                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.wheel: true,
                          },
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
                            Navigator.of(context)
                                .pop(); //dismiss the color picker
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.color_lens_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
