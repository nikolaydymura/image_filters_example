import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

part 'search_event.dart';

part 'search_state.dart';

EventTransformer<Event> debounceTime<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
}

abstract class SearchableBloc extends Bloc<SearchEvent, SearchState> {
  SearchableBloc(super.initialState);

  void search(String term) {
    add(StartSearchEvent(term));
  }

  void reset() {
    add(const ResetSearchEvent());
  }
}

mixin ShadersBloc on SearchableBloc {}
mixin CIImageBloc on SearchableBloc {}
mixin CIVideoBloc on SearchableBloc {}
mixin GPUVideoBloc on SearchableBloc {}

class SearchBloc extends SearchableBloc
    with ShadersBloc, CIImageBloc, CIVideoBloc, GPUVideoBloc {
  final List<String> _items;

  SearchBloc(
    Iterable<String> items,
  )   : _items = items.toList(),
        super(
          SearchSucceeded._(
            '',
            FocusNode(),
            TextEditingController(),
            SplayTreeSet<String>.from(
              items,
            ).toList(),
          ),
        ) {
    on<StartSearchEvent>(
      _onSearchStart,
      transformer: debounceTime(const Duration(milliseconds: 100)),
    );
    on<ResetSearchEvent>(_resetSearch);
  }

  void _onSearchStart(
    StartSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    final result = _items.where(
      (e) => e.toLowerCase().contains(event.term.toLowerCase()),
    );
    if (result.isEmpty) {
      emit(
        SearchEmpty(
          event.term,
          state.focusNode,
          state.controller,
        ),
      );
    } else {
      emit(
        SearchSucceeded._(
          event.term,
          state.focusNode,
          state.controller,
          SplayTreeSet<String>.from(
            result,
          ).toList(),
        ),
      );
    }
  }

  void _resetSearch(ResetSearchEvent event, Emitter<SearchState> emit) {
    emit(
      SearchSucceeded._(
        '',
        state.focusNode,
        state.controller,
        SplayTreeSet<String>.from(
          _items,
        ).toList(),
      ),
    );
    state.focusNode.unfocus();
  }
}
