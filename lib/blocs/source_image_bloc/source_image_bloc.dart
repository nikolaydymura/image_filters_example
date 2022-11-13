import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:rxdart/rxdart.dart';

part 'source_image_event.dart';

part 'source_image_state.dart';

class SourceImageBloc extends Cubit<SourceImageState> {
  SourceImageBloc() : super(SourceImageInitial());

  @override
  Stream<SourceImageState> get stream => super.stream.doOnListen(() {
        if (state is SourceImageInitial) {
          loadAsset('images/test.jpg');
        }
      });

  Future<void> loadFile(File file) async {
    final texture = await TextureSource.fromFile(file);
    emit(SourceImageReady(texture, file.absolute.path, false));
  }

  Future<void> loadAsset(String asset) async {
    final texture = await TextureSource.fromAsset(asset);
    emit(SourceImageReady(texture, asset, true));
  }
}

class Image1Bloc extends SourceImageBloc {
  Image1Bloc(FilterConfiguration configuration) {
    if (configuration is LookupTableShaderConfiguration) {
      changeLut(LUTSourceImage.lastSelected);
    } else {
      emit(ImageEmpty());
    }
  }

  void changeLut(Lut value) async {
    emit(LUTSourceImage(value));
    final texture = await TextureSource.fromAsset(value.asset);
    emit(LutSourceImageReady(value, texture));
  }
}
