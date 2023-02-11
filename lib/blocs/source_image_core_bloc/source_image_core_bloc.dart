import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

part 'source_image_core_state.dart';

class SourceImageCoreCubit extends Cubit<SourceImageCoreState> {
  final CIFilterConfiguration configuration;

  SourceImageCoreCubit(this.configuration) : super(SourceImageCoreInitial());

  @override
  Stream<SourceImageCoreState> get stream => super.stream.doOnListen(() {
        if (state is SourceImageCoreInitial) {
          prepare('images/inputImage1.jpg');
        }
      });

  Future<void> prepare(String assetPath) async {
    CIImagePreviewController sourceController =
        await CIImagePreviewController.fromAsset(assetPath);
    CIImagePreviewController destinationController =
        await CIImagePreviewController.fromAsset(assetPath);

    await configuration.prepare();
    await destinationController.connect(configuration);

    emit(
      SourceImageCoreReady(
        sourceController,
        destinationController,
        true,
      ),
    );
  }

  Future<void> loadImage() async {
    ImagePicker? picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      CIImagePreviewController sourceController =
          await CIImagePreviewController.fromMemory(bytes);
      CIImagePreviewController destinationController =
          await CIImagePreviewController.fromMemory(bytes);
      await configuration.prepare();
      await destinationController.connect(configuration);

      emit(
        SourceImageCoreReady(
          sourceController,
          destinationController,
          true,
        ),
      );
    }
  }
}
