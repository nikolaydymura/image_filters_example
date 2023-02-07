import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<Event> debounceTime<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<StartSearchEvent>(
      _onSearchStart,
      transformer: debounceTime(const Duration(milliseconds: 300)),
    );
  }

  void _onSearchStart(
    StartSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    if (event.term.length >= 3 && state is SearchInitial) {
      emit(SearchInProcessing());
      final items = _doSearch(event.filters, event.term);
      if (items.isNotEmpty) {
        emit(SearchSucceeded._([...items]));
      } else {
        emit(SearchEmpty());
      }
    } else if (event.term.length < 3) {
      emit(SearchInitial());
    } else if (event.term.length >= 3) {
      final items = _doSearch(event.filters, event.term);
      if (items.isNotEmpty) {
        emit(SearchSucceeded._([...items]));
      } else {
        emit(SearchEmpty());
      }
    }
  }

  void search(List<String> filters, String term) {
    add(StartSearchEvent(filters, term));
  }

  List<String> _doSearch(List<String> filters, String term) {
    final result = filters
        .where(
          (element) => element.toLowerCase().startsWith(term.toLowerCase()),
        )
        .toList();
    return result;
  }
}
