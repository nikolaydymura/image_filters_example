import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/external_image_texture.dart';
import '../../models/lut.dart';

part 'source_image_state.dart';

class SourceImageCubit extends Cubit<SourceImageState> {
  SourceImageCubit() : super(SourceImageInitial());

  @override
  Stream<SourceImageState> get stream => super.stream.doOnListen(() {
        if (state is SourceImageInitial) {
          loadAsset('images/inputImage.jpg');
        }
      });

  Future<void> loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path ?? '');
      final texture = await TextureSource.fromFile(file);
      emit(SourceImageReady(texture, file.absolute.path, false));
    } else {
      print('Nothing was selected');
    }
  }

  Future<void> loadAsset(String asset) async {
    final texture = await TextureSource.fromAsset(asset);
    emit(SourceImageReady(texture, asset, true));
  }
}

class Image1Cubit extends SourceImageCubit {
  Image1Cubit(FilterConfiguration configuration) {
    if (configuration is SquareLookupTableShaderConfiguration) {
      changeImage(LUTSourceImage.lastSquareSelected);
    } else if (configuration is HALDLookupTableShaderConfiguration) {
      changeImage(LUTSourceImage.lastHALDSelected);
    } else {
      emit(ImageEmpty());
    }
  }

  Future<void> changeImage(ExternalImageTexture value) async {
    if (value is AssetExternalImageTexture) {
      if (value is HALDLut) {
        emit(LUTSourceImage(value, false));
        final texture = await TextureSource.fromAsset(value.asset);
        emit(LutSourceImageReady(value, texture, false));
      } else if (value is SquareLut) {
        emit(LUTSourceImage(value, true));
        final texture = await TextureSource.fromAsset(value.asset);
        emit(LutSourceImageReady(value, texture, true));
      }
    } else if (value is FileExternalImageTexture) {}
  }
}
