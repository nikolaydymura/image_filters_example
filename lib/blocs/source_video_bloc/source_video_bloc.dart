import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'source_video_state.dart';

class SourceVideoCubit extends Cubit<SourceVideoState> {
  SourceVideoCubit()
      : super(
          SourceVideoInitial(
            [
              AssetInputSource('videos/BigBuckBunny.mp4'),
              AssetInputSource('videos/Mona.mp4'),
            ],
            0,
          ),
        );

  @override
  Stream<SourceVideoState> get stream => super.stream.doOnListen(() {
        if (state is SourceVideoInitial) {
          _prepare();
        }
      });

  Future<void> loadFile() async {
    ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final texture = await genThumbnailFile();
      emit(
        SourceVideoReady(
          [...state.sources, FileInputSource(File(video.path))],
          state.sources.length,
          texture,
        ),
      );
    }
  }

  Future<void> changeInput(PathInputSource value) async {
    final index = state.sources.indexOf(value);
    final texture = await genThumbnailFile();
    emit(SourceVideoReady(state.sources, index, texture));
  }

  Future<void> _prepare() async {
    final texture = await genThumbnailFile();
    emit(SourceVideoReady(state.sources, state.selectedIndex, texture));
  }

  Future<File> genThumbnailFile() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      thumbnailPath: '/Users/egorterekhov/StudioProjects',
      video: state.selected.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 80,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 30,
    );
    File file = File(fileName ?? '');
    return file;
  }
}
