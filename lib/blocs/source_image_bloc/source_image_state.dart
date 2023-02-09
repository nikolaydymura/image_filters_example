part of 'source_image_bloc.dart';

const List<Lut> kSquareImages = [
  SquareLut('lut/lookup_demo.png'),
  SquareLut('lut/lookup_amatorka.png'),
  SquareLut('lut/lookup_miss_etikate.png'),
  SquareLut('lut/lookup_soft_elegance_1.png'),
  SquareLut('lut/lookup_soft_elegance_2.png'),
  SquareLut('lut/filter_lut_1.png'),
  SquareLut('lut/filter_lut_2.png'),
  SquareLut('lut/filter_lut_3.png'),
  SquareLut('lut/filter_lut_4.png'),
  SquareLut('lut/filter_lut_5.png'),
];

const List<Lut> kHALDImages = [
  HALDLut('lut/ColorCubeReferenceImage64.png'),
  HALDLut('lut/NightVisionColorCube.png'),
  HALDLut('lut/JustBlueItColorCube.png'),
  HALDLut('lut/HotBlackColorCube.png'),
  HALDLut('lut/HighContrastBWColorCube.png'),
  HALDLut('lut/filter_lut_7.png'),
  HALDLut('lut/filter_lut_8.png'),
  HALDLut('lut/filter_lut_9.png'),
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

abstract class AdditionalSourceImageState<T extends ExternalImageTexture>
    extends SourceImageState {
  final T selected;

  List<T> get items;

  const AdditionalSourceImageState(this.selected);
}

class LUTSourceImage extends AdditionalSourceImageState<Lut> {
  static Lut lastSquareSelected = kSquareImages.first;
  static Lut lastHALDSelected = kHALDImages.first;

  final bool square;

  @override
  List<Lut> get items => square ? kSquareImages : kHALDImages;

  LUTSourceImage(super.selected, this.square) {
    if (square) {
      lastSquareSelected = selected;
    } else {
      lastHALDSelected = selected;
    }
  }

  @override
  List<Object?> get props => [selected, square];
}

class LutSourceImageReady extends AdditionalSourceImageState<Lut>
    implements SourceImageReady {
  @override
  final TextureSource textureSource;
  final bool square;

  const LutSourceImageReady(super.selected, this.textureSource, this.square);

  @override
  bool get asset => true;

  @override
  List<Lut> get items => square ? kSquareImages : kHALDImages;

  @override
  String get path => selected.asset;

  @override
  List<Object?> get props => [selected];
}
