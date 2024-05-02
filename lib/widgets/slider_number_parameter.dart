import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class SliderNumberParameterWidget extends StatelessWidget {
  final RangeNumberParameter parameter;
  final VoidCallback onChanged;

  const SliderNumberParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 3,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              parameter.displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
        ),
      ],
    );
  }
}
