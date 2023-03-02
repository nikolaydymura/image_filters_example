import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

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
      emit(
        SourceVideoReady(
          [...state.sources, FileInputSource(File(video.path))],
          state.sources.length,
        ),
      );
    }
  }

  Future<void> changeInput(PathInputSource value) async {
    final index = state.sources.indexOf(value);
    emit(SourceVideoReady(state.sources, index));
  }

  Future<void> _prepare() async {
    emit(SourceVideoReady(state.sources, state.selectedIndex));
  }
}
