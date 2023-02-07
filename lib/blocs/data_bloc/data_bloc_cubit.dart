import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

part 'data_bloc_state.dart';

class DataBlocCubit extends Cubit<DataBlocState> {
  static final _defaultItem = DefaultDataItem();
  final DataParameter parameter;
  final FilterConfiguration configuration;

  DataBlocCubit(this.parameter, this.configuration)
      : super(DataBlocState(_defaultItem, [_defaultItem])) {
    if (isHALDCube(parameter, configuration)) {
      emit(DataBlocState(_lutHALDImages.first, _lutHALDImages));
    } else if (isSquareCube(parameter, configuration)) {
      emit(DataBlocState(_lutSquareImages.first, _lutSquareImages));
    } else if (parameter.name == 'inputBackgroundImage' ||
        parameter.name == 'inputImage2' ||
        parameter.name == 'inputImageTexture2') {
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
      }
    }
    await parameter.update(configuration);
    emit(state.copyWith(selected: value));
  }

  static final List<DataItem> _backgroundImages = [
    _defaultItem,
    ImageAssetDataItem('images/inputBackgroundImage.png')
  ];

  static final List<DataItem> _lutHALDImages = [
    _defaultItem,
    LutAssetDataItem('lut/filter_lut_6.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_7.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_8.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_9.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_10.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_11.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/filter_lut_12.png', metadata: LutMetadata(8, 64, 8)),
    LutAssetDataItem('lut/img.png', metadata: LutMetadata(8, 64, 8)),
  ];

  static final List<DataItem> _lutSquareImages = [
    _defaultItem,
    LutAssetDataItem('lut/filter_lut_1.png', metadata: LutMetadata(64, 8, 8)),
    LutAssetDataItem('lut/filter_lut_2.png', metadata: LutMetadata(64, 8, 8)),
    LutAssetDataItem('lut/filter_lut_3.png', metadata: LutMetadata(64, 8, 8)),
    LutAssetDataItem('lut/filter_lut_4.png', metadata: LutMetadata(64, 8, 8)),
    LutAssetDataItem(
      'lut/lookup_amatorka.png',
      metadata: LutMetadata(64, 8, 8),
    ),
    LutAssetDataItem('lut/lookup_demo.png', metadata: LutMetadata(64, 8, 8)),
  ];

  void addItem(FileDataItem item) {
    if (isHALDCube(parameter, configuration)) {
      _lutHALDImages.add(item);
    } else if (isSquareCube(parameter, configuration)) {
      _lutSquareImages.add(item);
    }
  }
}

bool isSquareCube(
  DataParameter parameter,
  FilterConfiguration configuration,
) {
  if (parameter.name == 'inputTextureCubeData' &&
      configuration is SquareLookupTableShaderConfiguration) {
    return true;
  }
  if (parameter.name == 'inputTextureCubeData' &&
      configuration is GPUSquareLookupTableConfiguration) {
    return true;
  }
  if (parameter.name == 'inputImage2' &&
      configuration is CILookupTableConfiguration) {
    return true;
  }

  return false;
}

bool isHALDCube(
  DataParameter parameter,
  FilterConfiguration configuration,
) {
  if (parameter.name == 'inputCubeData' &&
      configuration is CIColorCubeConfiguration) {
    return true;
  }
  if (parameter.name == 'inputCubeData' &&
      configuration is CIColorCubeWithColorSpaceConfiguration) {
    return true;
  }
  if (parameter.name == 'inputCube0Data' &&
      configuration is CIColorCubesMixedWithMaskConfiguration) {
    return true;
  }
  if (parameter.name == 'inputCube1Data' &&
      configuration is CIColorCubesMixedWithMaskConfiguration) {
    return true;
  }

  if (parameter.name == 'inputTextureCubeData' &&
      configuration is HALDLookupTableShaderConfiguration) {
    return true;
  }
  if (parameter.name == 'inputTextureCubeData' &&
      configuration is GPUHALDLookupTableConfiguration) {
    return true;
  }

  return false;
}
