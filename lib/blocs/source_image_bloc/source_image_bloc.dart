// ignore_for_file: require_trailing_commas
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

part 'source_image_state.dart';

class SourceImageCubit extends Cubit<SourceImageState> {
  SourceImageCubit()
    : super(
        SourceImageInitial([
          AssetInputSource('images/inputImage1.jpg'),
          AssetInputSource('images/inputImage2.jpg'),
          AssetInputSource('images/inputImage3.png'),
          AssetInputSource('images/inputImage4.heic'),
          AssetInputSource('images/inputImage.jpg'),
        ], 0),
      );

  @override
  Stream<SourceImageState> get stream => super.stream.doOnListen(() {
    if (state is SourceImageInitial) {
      _prepare();
    }
  });

  Future<void> loadFile({XFile? image}) async {
    ImagePicker picker = ImagePicker();
    final XFile? photo =
        image ?? await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final texture = await TextureSource.fromFile(File(photo.path));
      emit(
        SourceImageReady(
          [...state.sources, FileInputSource(File(photo.path))],
          state.sources.length,
          texture,
        ),
      );
    }
  }

  Future<void> changeInput(InputSource value) async {
    if (value is PathInputSource) {
      final texture = await TextureSource.fromAsset(value.path);
      final index = state.sources.indexOf(value);
      emit(SourceImageReady(state.sources, index, texture));
    }
  }

  Future<void> _prepare() async {
    final source = state.selected;
    if (source is PathInputSource) {
      final texture = await TextureSource.fromAsset(source.path);
      emit(SourceImageReady(state.sources, state.selectedIndex, texture));
    }
  }

  void updateInitialState(String path) async {
    emit(SourceImageInitial([AssetInputSource(path)], 0));
  }
}
