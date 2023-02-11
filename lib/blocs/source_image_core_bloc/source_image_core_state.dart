part of 'source_image_core_bloc.dart';

abstract class SourceImageCoreState extends Equatable {
  const SourceImageCoreState();
}

class SourceImageCoreInitial extends SourceImageCoreState {
  @override
  List<Object?> get props => [];
}

class SourceImageCoreReady extends SourceImageCoreState {
  final CIImagePreviewController sourceController;
  final CIImagePreviewController destinationController;
  final bool controllersReady;

  const SourceImageCoreReady(
      this.sourceController, this.destinationController, this.controllersReady);

  @override
  List<Object?> get props =>
      [sourceController, destinationController, controllersReady];
}

class SourceImageCoreLoadReady extends SourceImageCoreState {
  final CIImagePreviewController sourceController;
  final CIImagePreviewController destinationController;
  final bool controllersReady;

  const SourceImageCoreLoadReady(
      this.sourceController, this.destinationController, this.controllersReady);

  @override
  List<Object?> get props =>
      [sourceController, destinationController, controllersReady];
}
