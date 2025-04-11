part of 'data_bloc_cubit.dart';

class DataBlocState {
  final DataItem? selected;
  final List<DataItem> items;

  DataBlocState(this.items, {this.selected});

  DataBlocState copyWith({DataItem? selected}) {
    return DataBlocState(items, selected: selected ?? this.selected);
  }
}

abstract class DataItemMetadata {}

abstract class DataItem {
  String get name;

  final DataItemMetadata? metadata;

  DataItem({this.metadata});
}

class AssetDataItem extends DataItem {
  final String asset;

  @override
  String get name => asset.split('/').last.split('.').first;

  AssetDataItem(this.asset, {super.metadata});
}

class FileDataItem extends DataItem {
  final File file;

  @override
  String get name => file.path.split('/').last.split('.').first;

  FileDataItem(this.file, {super.metadata});
}

class BinaryDataItem extends DataItem {
  final Uint8List bytes;
  @override
  final String name;

  BinaryDataItem(this.name, this.bytes, {super.metadata});
}

class ImageAssetDataItem extends AssetDataItem {
  ImageAssetDataItem(super.asset, {super.metadata});
}

class ImageFileDataItem extends FileDataItem {
  ImageFileDataItem(super.file, {super.metadata});
}

class ImageBinaryDataItem extends BinaryDataItem {
  ImageBinaryDataItem(super.name, super.bytes, {super.metadata});
}

class LutAssetDataItem extends ImageAssetDataItem {
  LutAssetDataItem(super.asset, {super.metadata});
}

class LutFileDataItem extends ImageFileDataItem {
  LutFileDataItem(super.file, {super.metadata});
}

class LutMetadata extends DataItemMetadata {
  final int dimension;
  final int size;
  final int rows;
  final int columns;

  LutMetadata(this.dimension, this.size, this.rows, this.columns);
}

class DefaultDataItem extends DataItem {
  @override
  String get name => '---Default---';
}
