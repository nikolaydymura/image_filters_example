import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/export_bloc/export_cubit.dart';

class ExportVideoButton extends StatelessWidget {
  final PathInputSource Function() sourceBuilder;
  final VideoFilterConfiguration configuration;

  const ExportVideoButton({
    super.key,
    required this.sourceBuilder,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExportCubit, ExportState>(
      listener: (context, state) {
        if (state is ExportCompleted) {
          final snackBar = SnackBar(
            content: Text(
              'Exported: ${state.path}, took ${state.duration.inSeconds} seconds',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is ExportFailed) {
          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text(state.message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is ExportProcessing) {
          return FloatingActionButton(
            onPressed: () {
              context.read<ExportCubit>().cancelExporting();
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.cancel,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        }
        return FloatingActionButton(
          onPressed: () {
            context.read<ExportCubit>().exportVideo(
                  sourceBuilder.call(),
                  configuration,
                );
          },
          child: const Icon(Icons.save),
        );
      },
    );
  }
}
