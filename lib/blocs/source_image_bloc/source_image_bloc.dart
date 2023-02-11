import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_picker/image_picker.dart';
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
    ImagePicker? picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();

      final texture = await TextureSource.fromMemory(bytes);
      emit(SourceImageReady(texture, image.path, false));
    } else {
      print('Nothing was selected');
    }
  }

  Future<void> loadAsset(String asset) async {
    final texture = await TextureSource.fromAsset(asset);
    emit(SourceImageReady(texture, asset, true));
  }
}
