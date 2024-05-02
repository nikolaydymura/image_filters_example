import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';
import '../blocs/string_option_bloc/string_option_cubit.dart';
import 'bool_parameter.dart';
import 'color_parameter.dart';
import 'data_dropdown_button_widget.dart';
import 'mat_parameter.dart';
import 'number_parameter.dart';
import 'point_parameter.dart';
import 'rect_parameter.dart';
import 'size_parameter.dart';
import 'slider_number_parameter.dart';
import 'string_option_dropdown_button_widget.dart';

extension ParametersContainer on FilterConfiguration {
  Iterable<Widget> children(void Function(ConfigurationParameter) onChanged) {
    final numbers = parameters
        .whereNot((e) => e.hidden)
        .whereType<NumberParameter>()
        .whereNot((e) => e is RangeNumberParameter)
        .map(
          (e) => NumberParameterWidget(
            parameter: e,
            onChanged: () {
              onChanged.call(e);
            },
          ),
        );
    final datas = parameters.whereType<DataParameter>().map(
          (e) => BlocProvider(
            create: (context) => DataBlocCubit(
              e,
              this,
              onChanged: onChanged,
            ),
            child: DataDropdownButtonWidget(
              parameter: e,
            ),
          ),
        );
    final variations = parameters.whereType<OptionStringParameter>().map(
          (e) => BlocProvider(
            create: (context) => StringOptionCubit(
              e,
              this,
            ),
            child: StringOptionDropdownButtonWidget(
              parameter: e,
            ),
          ),
        );
    final colors = parameters.whereType<ColorParameter>().map(
          (e) => ColorParameterWidget(
            parameter: e,
            onChanged: () {
              onChanged.call(e);
            },
          ),
        );
    final params = parameters
        .whereNot((e) => e.hidden)
        .whereNot((e) => e is NumberParameter && e is! RangeNumberParameter)
        .whereNot((e) => e is DataParameter)
        .whereNot((e) => e is ColorParameter)
        .whereNot((e) => e is OptionStringParameter)
        .map((e) {
      if (e is RangeNumberParameter) {
        return SliderNumberParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is PointParameter) {
        return PointParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is SizeParameter) {
        return SizeParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      }
      if (e is RectParameter) {
        return RectParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is Mat7Parameter) {
        return Mat7ParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is Mat5Parameter) {
        return Mat5ParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is Mat3Parameter) {
        return Mat3ParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is Mat4Parameter) {
        return Mat4ParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is BoolParameter) {
        return BoolParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      } else if (e is ListParameter) {
        return ListParameterWidget(
          parameter: e,
          onChanged: () {
            onChanged.call(e);
          },
        );
      }
      return Text('Unknown: ${e.displayName}');
    });

    return [
      if (numbers.isNotEmpty ||
          datas.isNotEmpty ||
          colors.isNotEmpty ||
          variations.isNotEmpty)
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [...numbers, ...datas, ...colors, ...variations],
        ),
      ...params,
    ];
  }
}
