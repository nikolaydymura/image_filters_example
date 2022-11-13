import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class SizeParameterWidget extends StatelessWidget {
  final SizeParameter parameter;
  final VoidCallback onChanged;
  final TextEditingController widthController;
  final TextEditingController heightController;

  const SizeParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
    required this.widthController,
    required this.heightController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = parameter.value.width;
    double height = parameter.value.height;
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
            onChanged: (value) {
              width = double.parse(value);
            },
            keyboardType: TextInputType.number,
            controller: widthController.text.isNotEmpty
                ? widthController
                : TextEditingController(text: parameter.value.width.toString()),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: (value) {
              height = double.parse(value);
            },
            keyboardType: TextInputType.number,
            controller: heightController.text.isNotEmpty
                ? heightController
                : TextEditingController(
                    text: parameter.value.height.toString(),
                  ),
          ),
        ),
        TextButton(
          onPressed: () => _setSize(width, height),
          child: const Text('APPLY'),
        )
      ],
    );
  }

  void _setSize(double width, double height) {
    parameter.value = Size(width, height);
    onChanged.call();
  }
}
