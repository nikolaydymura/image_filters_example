import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/source_video_bloc/source_video_bloc.dart';

class VideoDropdownButtonWidget extends StatelessWidget {
  const VideoDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceVideoCubit, SourceVideoState>(
      builder: (context, state) {
        return DropdownButton<PathInputSource>(
          value: state.selected,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 8,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          underline: Container(
            color: Theme.of(context).primaryColor,
          ),
          onChanged: (PathInputSource? value) {
            if (value != null) {
              context.read<SourceVideoCubit>().changeInput(value);
            } else {
              context.read<SourceVideoCubit>().loadFile();
            }
          },
          items: [newFileInput, ...state.sources.widgets].toList(),
        );
      },
    );
  }

  DropdownMenuItem<PathInputSource> get newFileInput =>
      DropdownMenuItem<PathInputSource>(
        value: null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 80,
          ),
          child: Row(
            children: const [Icon(Icons.file_upload), Text('File...')],
          ),
        ),
      );
}

extension on List<PathInputSource> {
  Iterable<DropdownMenuItem<PathInputSource>> get widgets => map(
        (e) => DropdownMenuItem<PathInputSource>(
          value: e,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 80,
            ),
            child: BlocBuilder<SourceVideoCubit, SourceVideoState>(
              builder: (context, state) {
                if (state is SourceVideoReady) {
                  final img = Image.file(state.textureSource);
                  return Row(
                    children: [
                      Image(image: img.image),
                      Expanded(
                        child: Text(
                          e.path.substring(
                            7,
                            e.path.indexOf('.'),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      );
}
