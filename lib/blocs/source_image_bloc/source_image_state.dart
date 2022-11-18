part of 'source_image_bloc.dart';

const List<Lut> kLutImages = [
  Lut('lut/filter_lut_1.png', 8, 8, 8),
  Lut('lut/filter_lut_2.png', 8, 8, 8),
  Lut('lut/filter_lut_3.png', 8, 8, 8),
  Lut('lut/filter_lut_4.png', 8, 8, 8),
  Lut('lut/filter_lut_5.png', 8, 8, 8),
  Lut('lut/filter_lut_6.png', 8, 64, 8),
  Lut('lut/filter_lut_7.png', 8, 64, 8),
  Lut('lut/filter_lut_8.png', 8, 64, 8),
  Lut('lut/filter_lut_9.png', 8, 64, 8),
  Lut('lut/filter_lut_10.png', 8, 64, 8),
  Lut('lut/filter_lut_11.png', 8, 64, 8),
  Lut('lut/filter_lut_12.png', 8, 64, 8),
  Lut('lut/filter_lut_13.png', 16, 1, 16),
  Lut('lut/lookup_demo.png', 8, 8, 8),
  Lut('lut/img.png', 8, 64, 8),
];

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

class ImageEmpty extends SourceImageState {
  @override
  List<Object?> get props => [];
}

abstract class AdditionalSourceImageState<T extends ExternalImageTexture> extends SourceImageState {
  final T selected;

  List<T> get items;

  const AdditionalSourceImageState(this.selected);

}

class LUTSourceImage extends AdditionalSourceImageState<Lut> {
  static Lut lastSelected = kLutImages.first;

  @override
  List<Lut> get items => kLutImages;

  LUTSourceImage(super.selected) {
    lastSelected = selected;
  }

  @override
  List<Object?> get props => [selected];
}

class LutSourceImageReady extends AdditionalSourceImageState<Lut>
    implements SourceImageReady {
  @override
  final TextureSource textureSource;

  const LutSourceImageReady(super.selected, this.textureSource);

  @override
  bool get asset => true;

  @override
  List<Lut> get items => kLutImages;

  @override
  String get path => selected.asset;

  @override
  List<Object?> get props => [selected];
}
