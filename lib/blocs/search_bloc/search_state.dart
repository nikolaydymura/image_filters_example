part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final String term;
  final FocusNode focusNode;

  @override
  List<Object> get props => [term];

  const SearchState(this.term, this.focusNode);
}

class SearchEmpty extends SearchState {
  const SearchEmpty(super.term, super.focusNode);
}

class SearchSucceeded extends SearchState {
  final List<String> items;

  const SearchSucceeded._(super.term, super.focusNode, this.items);

  @override
  List<Object> get props => [term, items];
}
