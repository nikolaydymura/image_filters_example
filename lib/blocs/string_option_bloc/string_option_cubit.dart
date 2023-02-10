import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

part 'string_option_state.dart';

class StringOptionCubit<T extends OptionString>
    extends Cubit<StringOptionState<T>> {
  final OptionStringParameter<T> parameter;
  final FilterConfiguration configuration;

  StringOptionCubit(this.parameter, this.configuration)
      : super(StringOptionState<T>());

  Future<void> change(T? value) async {
    emit(StringOptionState<T>(selected: value));
    await parameter.update(configuration);
  }
}
