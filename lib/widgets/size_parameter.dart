import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class SizeParameterWidget extends StatelessWidget {
  final SizeParameter parameter;
  final VoidCallback onChanged;

  const SizeParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                      parameter.value = parameter.value.copyWith(
                        width: parameter.value.width - 0.05,
                      );
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value = parameter.value.copyWith(
                        width: parameter.value.width + 0.05,
                      );
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = parameter.value.copyWith(width: value);
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.width.toStringAsFixed(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value = parameter.value.copyWith(
                        height: parameter.value.height - 0.05,
                      );
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value = parameter.value.copyWith(
                        height: parameter.value.height + 0.05,
                      );
                      onChanged.call();
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = parameter.value.copyWith(height: value);
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.height.toStringAsFixed(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
