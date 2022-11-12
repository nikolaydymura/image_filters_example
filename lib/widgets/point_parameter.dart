import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';

class PointParameterWidget extends StatelessWidget {
  final PointParameter parameter;
  final VoidCallback onChanged;
  final TextEditingController xController;
  final TextEditingController yController;

  const PointParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
    required this.xController,
    required this.yController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double xPoint = parameter.value.x;
    double yPoint = parameter.value.y;
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
        Expanded(
          child: TextField(
            onChanged: (value) {
              xPoint = double.parse(value);
            },
            keyboardType: TextInputType.number,
            controller: xController.text.isNotEmpty
                ? xController
                : TextEditingController(text: parameter.value.x.toString()),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: (value) {
              yPoint = double.parse(value);
            },
            keyboardType: TextInputType.number,
            controller: yController.text.isNotEmpty
                ? yController
                : TextEditingController(text: parameter.value.y.toString()),
          ),
        ),
        TextButton(
          onPressed: () => _setPoint(xPoint, yPoint),
          child: const Text('APPLY'),
        )
      ],
    );
  }

  void _setPoint(double xPoint, double yPoint) {
    parameter.value = Point(xPoint, yPoint);
    onChanged.call();
  }
}
