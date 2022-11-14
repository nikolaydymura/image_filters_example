import 'external_image_texture.dart';

class Lut extends AssetExternalImageTexture {
  final int size;
  final int rows;
  final int columns;

  const Lut(super.asset, this.size, this.rows, this.columns);

  @override
  String get name => asset.split('/').last.split('.').first;
}