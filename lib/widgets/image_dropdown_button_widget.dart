import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';

class ImageDropdownButtonWidget extends StatelessWidget {
  const ImageDropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 24, 120),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SourceImageCubit, SourceImageState>(
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
                    context.read<SourceImageCubit>().loadFile();
                  }
                },
                items: state.sources
                    .map<DropdownMenuItem<InputSource>>((InputSource value) {
                  return DropdownMenuItem<InputSource>(
                    value: value,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(
                          MediaQuery.of(context).size.width / 2 - (32 + 24),
                          120,
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 80,
                          maxHeight: 80,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _dataPreview(value),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }

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
