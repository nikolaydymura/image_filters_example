part of 'source_video_bloc.dart';

abstract class SourceVideoState extends Equatable {
  final List<PathInputSource> sources;
  final int selectedIndex;

  PathInputSource get selected => sources[selectedIndex];

  const SourceVideoState(this.sources, this.selectedIndex);

  @override
  List<Object?> get props => [sources, selectedIndex];
}

class SourceVideoInitial extends SourceVideoState {
  const SourceVideoInitial(super.sources, super.selectedIndex);

  @override
  List<Object?> get props => [sources];
}

class SourceVideoReady extends SourceVideoState {
  final File textureSource;

  const SourceVideoReady(
    super.sources,
    super.selectedIndex,
    this.textureSource,
  );

  @override
  List<Object?> get props => [...super.props, textureSource];
}
