import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/string_option_bloc/string_option_cubit.dart';

class StringOptionDropdownButtonWidget<T extends OptionString>
    extends StatelessWidget {
  final OptionStringParameter<T> parameter;

  const StringOptionDropdownButtonWidget({
    super.key,
    required this.parameter,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 24, 120),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              parameter.displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<StringOptionCubit<T>, StringOptionState<T>>(
            builder: (context, state) {
              return DropdownButton<T>(
                value: state.selected,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 8,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                underline: Container(
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (T? value) {
                  context.read<StringOptionCubit<T>>().change(value);
                },
                items: parameter.values.map<DropdownMenuItem<T>>((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(
                          MediaQuery.of(context).size.width / 2 - (32 + 24),
                          120,
                        ),
                      ),
                      child: Text(
                        value.platformKey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
