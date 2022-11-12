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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: TextField(
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(12.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            textAlign: TextAlign.center,
            controller:
                TextEditingController(text: parameter.value.red.toString()),
            onSubmitted: (value) {
              final colorValue = int.tryParse(value);
              if (colorValue != null && colorValue >= 0 && colorValue <= 256) {
                parameter.value = parameter.value.withRed(colorValue);
                onChanged.call();
              }
            },
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: TextField(
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(12.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            textAlign: TextAlign.center,
            controller:
                TextEditingController(text: parameter.value.green.toString()),
            onSubmitted: (value) {
              final colorValue = int.tryParse(value);
              if (colorValue != null && colorValue >= 0 && colorValue <= 256) {
                parameter.value = parameter.value.withGreen(colorValue);
                onChanged.call();
              }
            },
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 60),
          child: TextField(
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(12.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            textAlign: TextAlign.center,
            controller:
                TextEditingController(text: parameter.value.blue.toString()),
            onSubmitted: (value) {
              final colorValue = int.tryParse(value);
              if (colorValue != null && colorValue >= 0 && colorValue <= 256) {
                parameter.value = parameter.value.withBlue(colorValue);
                onChanged.call();
              }
            },
          ),
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
        )
      ],
    );
  }
}
