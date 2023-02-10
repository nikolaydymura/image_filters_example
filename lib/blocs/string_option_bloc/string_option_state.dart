part of 'string_option_cubit.dart';

class StringOptionState<T> extends Equatable {
  final T? selected;

  const StringOptionState({this.selected});

  @override
  List<Object?> get props => [selected];
}
