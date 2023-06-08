import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';

class ImageDropdownButtonWidget extends StatelessWidget {
  const ImageDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceImageCubit, SourceImageState>(
      builder: (context, state) {
        return DropdownButton<InputSource>(
          value: state.selected,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 8,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          underline: Container(
            color: Theme.of(context).primaryColor,
          ),
          onChanged: (InputSource? value) {
            if (value != null) {
              context.read<SourceImageCubit>().changeInput(value);
            } else {
              context.read<SourceImageCubit>().loadFile();
            }
          },
          items: [newFileInput, ...state.sources.widgets].toList(),
        );
      },
    );
  }

  DropdownMenuItem<InputSource> get newFileInput =>
      DropdownMenuItem<InputSource>(
        value: null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 80,
          ),
          child: const Row(
            children: [Icon(Icons.file_upload), Text('File...')],
          ),
        ),
      );
}

extension on List<InputSource> {
  Iterable<DropdownMenuItem<InputSource>> get widgets => map(
        (e) => DropdownMenuItem<InputSource>(
          value: e,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 80,
              maxHeight: 80,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dataPreview(e),
            ),
          ),
        ),
      );

  Widget _dataPreview(InputSource value) {
    if (value is AssetInputSource) {
      return Image.asset(value.path);
    } else if (value is FileInputSource) {
      return Image.file(value.file);
    } else if (value is DataInputSource) {
      return Image.memory(value.data);
    }
    return const Icon(Icons.raw_on);
  }
}
