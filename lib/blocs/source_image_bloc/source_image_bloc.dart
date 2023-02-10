import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:rxdart/rxdart.dart';

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
