import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class NumberParameterWidget extends StatelessWidget {
  final NumberParameter parameter;
  final VoidCallback onChanged;
  final TextEditingController controller;

  const NumberParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
    required this.controller,
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
            onSubmitted: (value) {
              parameter.value = double.parse(value);
              onChanged.call();
            },
            keyboardType: TextInputType.number,
            controller: controller.text.isNotEmpty
                ? controller
                : TextEditingController(text: parameter.value.toString()),
          ),
        ),
        IconButton(
          onPressed: () {
            parameter.value =
                num.parse((parameter.value - 0.01).toStringAsFixed(2));
            onChanged.call();
          },
          icon: const Icon(Icons.remove_circle),
        ),
        IconButton(
          onPressed: () {
            parameter.value =
                num.parse((parameter.value + 0.01).toStringAsFixed(2));
            onChanged.call();
          },
          icon: const Icon(Icons.add_circle),
        ),
      ],
    );
  }
}
