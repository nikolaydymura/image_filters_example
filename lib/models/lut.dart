import 'external_image_texture.dart';

abstract class Lut extends AssetExternalImageTexture {
  const Lut(super.asset);

  @override
  String get name => asset.split('/').last.split('.').first;
}

class HALDLut extends Lut {
  const HALDLut(super.asset);
}

class SquareLut extends Lut {
  const SquareLut(super.asset);
}
