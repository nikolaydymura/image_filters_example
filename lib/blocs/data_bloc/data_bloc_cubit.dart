import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';

part 'data_bloc_state.dart';

class DataBlocCubit extends Cubit<DataBlocState> {
  final DataParameter parameter;
  final FilterConfiguration configuration;
  final void Function(ConfigurationParameter)? onChanged;

  DataBlocCubit(this.parameter, this.configuration, {this.onChanged})
      : super(DataBlocState([])) {
    if (isHALDCube(parameter, configuration)) {
      emit(DataBlocState(_lutHALDImages));
    } else if (isSquareCube(parameter, configuration)) {
      emit(DataBlocState(_lutSquareImages));
    } else
    /*if (parameter.name == 'inputBackgroundImage' ||
        parameter.name == 'inputImage2' ||
        parameter.name == 'inputImageTexture2' ||
        parameter.name == 'inputTextureToneCurve')*/
    {
      emit(DataBlocState(_backgroundImages));
    }
  }

  Future<void> change(DataItem value, {bool append = false}) async {
    if (value is AssetDataItem) {
      parameter.asset = value.asset;
      parameter.file = null;
      parameter.data = null;
    } else if (value is FileDataItem) {
      parameter.file = value.file;
      parameter.asset = null;
      parameter.data = null;
    } else if (value is BinaryDataItem) {
      parameter.data = value.bytes;
      parameter.file = null;
      parameter.asset = null;
    }
    final metadata = value.metadata;
    if (metadata is LutMetadata) {
      final config = configuration;
      if (config is CubeDimensionMixin) {
        config.cubeDimension = metadata.dimension;
        final parameter = configuration.parameters
            .firstWhere((e) => e.name == 'inputCubeDimension');
        onChanged?.call(parameter);
      }
    }
    await parameter.update(configuration);
    if (append) {
      emit(
        DataBlocState(
          [value, ...state.items],
          selected: value,
        ),
      );
    } else {
      emit(state.copyWith(selected: value));
    }
  }

  Future<void> loadFile() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final file = File(image.path);
        final item = ImageBinaryDataItem(
          file.uri.pathSegments.last,
          await file.readAsBytes(),
        );
        await change(item, append: true);
      } catch (e, trace) {
        debugPrintStack(stackTrace: trace);
      }
    }
  }

  static final List<DataItem> _backgroundImages = [
    ImageAssetDataItem('images/inputBackgroundImage.png'),
    ImageAssetDataItem('images/inputWatermarkImage.png'),
  ];

  static final List<DataItem> _lutHALDImages = [
    LutAssetDataItem(
      'lut/ColorCubeReferenceImage64.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/NightVisionColorCube.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/JustBlueItColorCube.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/HotBlackColorCube.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/HighContrastBWColorCube.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_7.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_8.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_9.png',
      metadata: LutMetadata(64),
    ),
  ];

  static final List<DataItem> _lutSquareImages = [
    LutAssetDataItem(
      'lut/lookup_demo.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/lookup_amatorka.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/lookup_miss_etikate.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/lookup_soft_elegance_1.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/lookup_soft_elegance_2.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_1.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_2.png',
      metadata: LutMetadata(64),
    ),
    LutAssetDataItem(
      'lut/filter_lut_3.png',
      metadata: LutMetadata(64),
    ),
  ];
}

bool isSquareCube(
  DataParameter parameter,
  FilterConfiguration configuration,
) {
  if (parameter.name == 'inputTextureCubeData' &&
      configuration is BunchShaderConfiguration) {
    return configuration
        .configurations<SquareLookupTableShaderConfiguration>()
        .isNotEmpty;
  }
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
      configuration is BunchShaderConfiguration) {
    return configuration
        .configurations<HALDLookupTableShaderConfiguration>()
        .isNotEmpty;
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
