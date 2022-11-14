import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class NumberParameterWidget extends StatelessWidget {
  final NumberParameter parameter;
  final VoidCallback onChanged;

  const NumberParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
  }) : super(key: key);

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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: InkWell(
              onTap: () {
                parameter.value -= 0.05;
                onChanged.call();
              },
              child: const Icon(
                Icons.arrow_downward,
              ),
            ),
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
      ],
    );
  }
}
