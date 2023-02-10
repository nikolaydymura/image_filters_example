part of 'source_image_bloc.dart';

abstract class SourceImageState extends Equatable {
  const SourceImageState();
}

class SourceImageInitial extends SourceImageState {
  @override
  List<Object?> get props => [];
}

class SourceImageReady extends SourceImageState {
  final String path;
  final bool asset;
  final TextureSource textureSource;

  const SourceImageReady(this.textureSource, this.path, this.asset);

  @override
  List<Object?> get props => [path, asset];
}
