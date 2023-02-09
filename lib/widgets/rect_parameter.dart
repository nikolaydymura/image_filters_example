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
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(left: parameter.value.left - 10.0);
                          onChanged.call();
                        },
                        child: const Icon(
                          Icons.arrow_downward,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(left: parameter.value.left + 10.0);
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
                        parameter.value = parameter.value.copyWith(left: value);
                        onChanged.call();
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                      text: parameter.value.left.toStringAsFixed(2),
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
                          parameter.value = parameter.value
                              .copyWith(top: parameter.value.top - 10.0);
                          onChanged.call();
                        },
                        child: const Icon(
                          Icons.arrow_downward,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(top: parameter.value.top + 10.0);

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
                        parameter.value = parameter.value.copyWith(top: value);
                        onChanged.call();
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                      text: parameter.value.top.toStringAsFixed(2),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(width: parameter.value.width - 10.0);

                          onChanged.call();
                        },
                        child: const Icon(
                          Icons.arrow_downward,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(width: parameter.value.width + 10.0);

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
                        parameter.value =
                            parameter.value.copyWith(width: value);
                        onChanged.call();
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                      text: parameter.value.width.toStringAsFixed(2),
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
                          parameter.value = parameter.value
                              .copyWith(height: parameter.value.height - 10.0);
                          onChanged.call();
                        },
                        child: const Icon(
                          Icons.arrow_downward,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          parameter.value = parameter.value
                              .copyWith(height: parameter.value.height + 10.0);

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
                        parameter.value =
                            parameter.value.copyWith(height: value);
                        onChanged.call();
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                      text: parameter.value.height.toStringAsFixed(2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
