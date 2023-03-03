import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'source_video_state.dart';

class SourceVideoCubit extends Cubit<SourceVideoState> {
  SourceVideoCubit()
      : super(
    SourceVideoState(
            [
              AssetInputSource('videos/BigBuckBunny.mp4'),
              AssetInputSource('videos/Mona.mp4'),
            ],
            0,
            const <PathInputSource, Uint8List?>{},
          ),
        );

  Future<void> loadFile() async {
    ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final value = FileInputSource(File(video.path));
      final textures = Map.of(state.previews);
      try {
        final texture = await VideoThumbnail.thumbnailData(
          video: value.path,
          maxHeight: 80,
          maxWidth: 80,
        );
        textures[value] = texture;
      } finally {
        emit(
          SourceVideoState(
            [...state.sources, value],
            state.sources.length,
            textures,
          ),
        );
      }
    }
  }

  Future<void> changeInput(PathInputSource value) async {
    final index = state.sources.indexOf(value);
    emit(SourceVideoState(state.sources, index, state.previews));
  }
}
