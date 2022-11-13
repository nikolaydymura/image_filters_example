part of 'source_image_bloc.dart';

abstract class SourceImageEvent extends Equatable {
  const SourceImageEvent();
}

class LoadFileSourceImageEvent extends SourceImageEvent {
  final File file;

  const LoadFileSourceImageEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class LoadAssetSourceImageEvent extends SourceImageEvent {
  final String asset;

  const LoadAssetSourceImageEvent(this.asset);

  @override
  List<Object?> get props => [asset];
}
