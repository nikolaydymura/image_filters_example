import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class PointParameterWidget extends StatelessWidget {
  final PointParameter parameter;
  final VoidCallback onChanged;

  const PointParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value -= const Point<double>(0.05, 0.0);
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value += const Point<double>(0.05, 0.0);
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = parameter.value.copyWith(x: value);
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.x.toStringAsFixed(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value -= const Point<double>(0.00, 0.05);
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value += const Point<double>(0.0, 0.05);
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = parameter.value.copyWith(y: value);
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.y.toStringAsFixed(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
