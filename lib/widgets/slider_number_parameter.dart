import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class SliderNumberParameterWidget extends StatelessWidget {
  final RangeNumberParameter parameter;
  final VoidCallback onChanged;

  const SliderNumberParameterWidget({
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
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            parameter.value.toStringAsFixed(3),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            label: parameter.value.toDouble().toStringAsFixed(3),
            value: parameter.value.toDouble(),
            max: parameter.max?.toDouble() ?? double.infinity,
            min: parameter.min?.toDouble() ?? double.minPositive,
            onChanged: (value) {
              parameter.value = value;
              onChanged.call();
            },
          ),
        )
      ],
    );
  }
}
