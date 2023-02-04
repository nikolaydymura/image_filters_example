import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class RectParameterWidget extends StatelessWidget {
  final RectParameter parameter;
  final VoidCallback onChanged;

  const RectParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double valueDouble = 10.0;
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
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(valueDouble++, 0.0, 0.0, 0.0);
                      onChanged.call();
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(valueDouble--, 0.0, 0.0, 0.0);
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = Rect.fromLTWH(
                      parameter.value.left,
                      value,
                      value,
                      value,
                    );
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.left.toStringAsFixed(3),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, valueDouble++, 0.0, 0.0);
                      onChanged.call();
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, valueDouble--, 0.0, 0.0);
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = Rect.fromLTWH(
                      value,
                      parameter.value.left,
                      value,
                      value,
                    );
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.top.toStringAsFixed(3),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, 0.0, valueDouble++,  0.0);
                      onChanged.call();
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, 0.0, valueDouble--, 0.0);
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = Rect.fromLTWH(
                      value,
                      value,
                      parameter.value.left,
                      value,
                    );
                    onChanged.call();
                  }
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: parameter.value.width.toStringAsFixed(3),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, 0.0, 0.0, valueDouble++);
                      onChanged.call();
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      parameter.value =
                          Rect.fromLTWH(0.0, 0.0, 0.0, valueDouble--);
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                ),
                onSubmitted: (inputValue) {
                  final value = double.tryParse(inputValue);
                  if (value != null) {
                    parameter.value = Rect.fromLTWH(
                      value,
                      value,
                      parameter.value.left,
                      value,
                    );
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
