part of 'source_image_shader_bloc.dart';

abstract class SourceImageShaderState extends Equatable {
  const SourceImageShaderState();
}

class SourceImageShaderInitial extends SourceImageShaderState {
  @override
  List<Object?> get props => [];
}

class SourceImageShaderReady extends SourceImageShaderState {
  final String path;
  final bool asset;
  final TextureSource textureSource;

  const SourceImageShaderReady(this.textureSource, this.path, this.asset);

  @override
  List<Object?> get props => [path, asset];
}
