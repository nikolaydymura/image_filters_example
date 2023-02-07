part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];

  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchInProcessing extends SearchState {}

class SearchSucceeded extends SearchState {
  final List<String> items;

  const SearchSucceeded._(this.items);

  @override
  List<Object> get props => [items];
}

class SearchFailed extends SearchState {
  final String errorMessage;

  const SearchFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
