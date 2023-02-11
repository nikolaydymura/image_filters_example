import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:rxdart/rxdart.dart';

part 'source_image_shader_state.dart';

class SourceImageShaderCubit extends Cubit<SourceImageShaderState> {
  SourceImageShaderCubit() : super(SourceImageShaderInitial());

  @override
  Stream<SourceImageShaderState> get stream => super.stream.doOnListen(() {
        if (state is SourceImageShaderInitial) {
          loadAsset('images/inputImage.jpg');
        }
      });

  Future<void> loadFile(File file) async {
    final texture = await TextureSource.fromFile(file);
    emit(SourceImageShaderReady(texture, file.absolute.path, false));
  }

  Future<void> loadAsset(String asset) async {
    final texture = await TextureSource.fromAsset(asset);
    emit(SourceImageShaderReady(texture, asset, true));
  }
}
