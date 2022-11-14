import 'dart:io';

abstract class ExternalImageTexture {
  final String name;

  const ExternalImageTexture(this.name);
}

class FileExternalImageTexture extends ExternalImageTexture {
  final File file;

  FileExternalImageTexture(this.file) : super(file.path);
}

class AssetExternalImageTexture extends ExternalImageTexture {
  final String asset;

  const AssetExternalImageTexture(this.asset) : super(asset);
}
