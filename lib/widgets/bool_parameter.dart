import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class BoolParameterWidget extends StatelessWidget {
  final BoolParameter parameter;
  final VoidCallback onChanged;

  const BoolParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          parameter.displayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: parameter.value,
          onChanged: (value) {
            parameter.value = value;
            onChanged.call();
          },
        ),
      ],
    );
  }
}
