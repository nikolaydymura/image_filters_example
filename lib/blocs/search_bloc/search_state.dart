part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final String term;
  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  List<Object> get props => [term];

  const SearchState(this.term, this.focusNode, this.controller);
}

class SearchEmpty extends SearchState {
  const SearchEmpty(super.term, super.focusNode, super.controller);
}

class SearchSucceeded extends SearchState {
  final List<String> items;

  const SearchSucceeded._(
    super.term,
    super.focusNode,
    super.controller,
    this.items,
  );

  @override
  List<Object> get props => [term, items];
}
