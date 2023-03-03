part of 'source_video_bloc.dart';

class SourceVideoState extends Equatable {
  final List<PathInputSource> sources;
  final Map<PathInputSource, Uint8List?> previews;
  final int selectedIndex;

  PathInputSource get selected => sources[selectedIndex];

  const SourceVideoState(this.sources, this.selectedIndex, this.previews);

  @override
  List<Object?> get props => [sources, selectedIndex, previews];
}
