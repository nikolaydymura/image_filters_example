part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class StartSearchEvent extends SearchEvent {
  final String term;

  const StartSearchEvent(this.term);

  @override
  List<Object?> get props => [term];
}

class ResetSearchEvent extends SearchEvent {
  const ResetSearchEvent();
}
