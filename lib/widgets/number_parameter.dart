import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class NumberParameterWidget extends StatelessWidget {
  final NumberParameter parameter;
  final VoidCallback onChanged;

  const NumberParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 16, 170),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: parameter.displayName,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: InkWell(
            onTap: () {
              parameter.value -= 0.05;
              onChanged.call();
            },
            child: const Icon(
              Icons.arrow_downward,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          prefixIconColor: Theme.of(context).primaryColor,
          suffixIconColor: Theme.of(context).primaryColor,
          suffixIcon: InkWell(
            onTap: () {
              parameter.value += 0.05;
              onChanged.call();
            },
            child: const Icon(
              Icons.arrow_upward,
            ),
          ),
        ),
        onSubmitted: (inputValue) {
          final value = double.tryParse(inputValue);
          if (value != null) {
            parameter.value = value;
            onChanged.call();
          }
        },
        keyboardType: TextInputType.number,
        controller:
            TextEditingController(text: parameter.value.toStringAsFixed(3)),
      ),
    );
  }
}
