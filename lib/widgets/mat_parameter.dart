import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class Mat7ParameterWidget extends StatelessWidget {
  final Mat7Parameter parameter;
  final VoidCallback onChanged;

  const Mat7ParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width * 0.85,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemCount: 49,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: TextField(
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(1),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value = parameter.value.copyWith(
                        items: {index: value},
                      );
                      onChanged.call();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Mat5ParameterWidget extends StatelessWidget {
  final Mat5Parameter parameter;
  final VoidCallback onChanged;

  const Mat5ParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width / 2,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 2.0,
            ),
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(1),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value = parameter.value.copyWith(
                        items: {index: value},
                      );
                      onChanged.call();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Mat3ParameterWidget extends StatelessWidget {
  final Mat3Parameter parameter;
  final VoidCallback onChanged;

  const Mat3ParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width / 3,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3.0,
            ),
            itemCount: 9,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(1),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value = parameter.value.copyWith(
                        items: {index: value},
                      );
                      onChanged.call();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Mat4ParameterWidget extends StatelessWidget {
  final Mat4Parameter parameter;
  final VoidCallback onChanged;

  const Mat4ParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width / 3,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3.0,
            ),
            itemCount: 16,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(1),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value = parameter.value.copyWith(
                        items: {index: value},
                      );
                      onChanged.call();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ListParameterWidget extends StatelessWidget {
  final ListParameter parameter;
  final VoidCallback onChanged;

  const ListParameterWidget({
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
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: parameter.values.length <= 5 ? 48 : 96,
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: max(5, parameter.values.length ~/ 2),
              childAspectRatio: 2.0,
            ),
            itemCount: parameter.values.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(1),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value =
                          parameter.value
                              .mapIndexed((i, e) => i == index ? value : e)
                              .toList();
                      onChanged.call();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
