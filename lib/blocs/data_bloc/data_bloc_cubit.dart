import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

part 'data_bloc_state.dart';

class DataBlocCubit extends Cubit<DataBlocState> {
  static final _defaultItem = DefaultDataItem();
  final DataParameter parameter;
  final FilterConfiguration configuration;

  DataBlocCubit(this.parameter, this.configuration)
      : super(DataBlocState(_defaultItem, [_defaultItem])) {
    if (parameter.name == 'inputCubeData' &&
        configuration is CIColorCubeConfiguration) {
      emit(DataBlocState(_lutImages.first, _lutImages));
    } else if (parameter.name == 'inputTextureCubeData' &&
        configuration is LookupTableShaderConfiguration) {
      emit(DataBlocState(_lutImages.first, _lutImages));
    } else if (parameter.name == 'inputImage2' &&
        configuration is CILookupTableConfiguration) {
      emit(DataBlocState(_lutImages.first, _lutImages));
    } else if (parameter.name == 'inputBackgroundImage' ||
        parameter.name == 'inputImage2') {
      emit(DataBlocState(_backgroundImages.first, _backgroundImages));
    }
  }

  Future<void> change(DataItem value) async {
    if (value is AssetDataItem) {
      parameter.asset = value.asset;
    } else if (value is FileDataItem) {
      parameter.file = value.file;
    } else if (value is BinaryDataItem) {
      parameter.data = value.bytes;
    }
    final metadata = value.metadata;
    if (metadata is LutMetadata) {
      final config = configuration;
      if (config is CIColorCubeConfiguration) {
        config.cubeDimension = 64;
      } else if (config is LookupTableShaderConfiguration) {
        config.size = metadata.size.toDouble();
        config.rows = metadata.rows.toDouble();
        config.columns = metadata.columns.toDouble();
      } else if (config is CILookupTableConfiguration) {
        config.size = metadata.size;
        config.rows = metadata.rows;
        config.columns = metadata.columns;
      }
    }
    await parameter.update(configuration);
    emit(state.copyWith(selected: value));
  }

  static final List<DataItem> _backgroundImages = [
    _defaultItem,
    ImageAssetDataItem('images/inputBackgroundImage.png')
  ];

  static final List<DataItem> _lutImages = [
    _defaultItem,
    LutAssetDataItem('lut/filter_lut_1.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/filter_lut_2.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/filter_lut_3.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/filter_lut_4.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/filter_lut_5.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/filter_lut_6.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_7.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_8.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_9.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_10.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_11.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_12.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_13.png', metadata: LutMetadata(16, 1, 16)),
    LutAssetDataItem('lut/lookup_demo.png', metadata: LutMetadata(8, 8, 8)),
    LutAssetDataItem('lut/img.png', metadata: LutMetadata(8, 64, 8)),
  ];

  void addItem(FileDataItem item) {
    if (parameter.name == 'inputCubeData' &&
        configuration is CIColorCubeConfiguration) {
      _lutImages.add(item);
    } else if (parameter.name == 'inputTextureCubeData' &&
        configuration is LookupTableShaderConfiguration) {
      _lutImages.add(item);
    } else if (parameter.name == 'inputImage2' &&
        configuration is CILookupTableConfiguration) {
      _lutImages.add(item);
    }
  }
}
