part of 'source_image_bloc.dart';

abstract class SourceImageState extends Equatable {
  final List<InputSource> sources;
  final int selectedIndex;

  InputSource get selected => sources[selectedIndex];

  const SourceImageState(this.sources, this.selectedIndex);

  @override
  List<Object?> get props => [sources, selectedIndex];
}

class SourceImageInitial extends SourceImageState {
  const SourceImageInitial(super.sources, super.selectedIndex);

  @override
  List<Object?> get props => [sources];
}

class SourceImageReady extends SourceImageState {
  final TextureSource textureSource;

  const SourceImageReady(
    super.sources,
    super.selectedIndex,
    this.textureSource,
  );

  @override
  List<Object?> get props => [...super.props, textureSource];
}
