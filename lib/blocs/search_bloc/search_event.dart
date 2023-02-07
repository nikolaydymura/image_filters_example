part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class StartSearchEvent extends SearchEvent {
  final List<String> filters;
  final String term;

  const StartSearchEvent(this.filters, this.term);

  @override
  List<Object?> get props => [filters, term];
}
