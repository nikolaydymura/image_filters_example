import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  StreamSubscription<double>? processingListener;

  ExportCubit() : super(ExportInitial());

  @override
  Future<void> close() async {
    await processingListener?.cancel();
    return super.close();
  }

  void cancelExporting() {
    processingListener?.cancel();
    if (processingListener != null) {
      processingListener = null;
      emit(ExportInitial());
    }
  }

  Future<void> exportVideo(
    PathInputSource source,
    VideoFilterConfiguration configuration,
  ) async {
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${source.path.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    final processStream = configuration.exportVideoFile(
      VideoExportConfig(source, output),
    );
    processingListener = processStream.listen(
      (progress) {
        emit(ExportProcessing(progress));
      },
      onDone: () async {
        debugPrint('Exported: ${output.absolute}');
        try {
          final status = await PhotoManager.requestPermissionExtend(
            requestOption: const PermissionRequestOption(
              androidPermission: AndroidPermission(
                type: RequestType.video,
                mediaLocation: false,
              ),
            ),
          );
          if (status.isAuth || status.hasAccess) {
            await PhotoManager.editor.saveVideo(
              output,
              title: output.uri.pathSegments.last,
            );
          }
        } catch (e, s) {
          debugPrint('Error saving file to gallery: $e');
          debugPrintStack(stackTrace: s);
          rethrow;
        }
        emit(
          ExportCompleted(
            output.absolute.path,
            Duration(milliseconds: watch.elapsedMilliseconds),
          ),
        );
        processingListener = null;
      },
      onError: (error, trace) {
        emit(ExportFailed(error.toString()));
        emit(ExportInitial());
        debugPrintStack(stackTrace: trace);
        processingListener = null;
      },
    );
  }
}
