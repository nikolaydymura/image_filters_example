import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class BoolParameterWidget extends StatelessWidget {
  final BoolParameter parameter;
  final VoidCallback onChanged;

  const BoolParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
  }) : super(key: key);

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
        TextButton(
          onPressed: () {
            if (parameter.value == false) {
              parameter.value = true;
            } else {
              parameter.value = false;
            }
            onChanged.call();
          },
          child: Text(
            '${parameter.value}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
