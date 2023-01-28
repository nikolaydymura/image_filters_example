import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:path_provider/path_provider.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';
import '../widgets/color_parameter.dart';
import '../widgets/data_dropdown_button_widget.dart';
import '../widgets/number_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/slider_number_parameter.dart';

class CIFilterVideoDetailsPage extends StatefulWidget {
  final CIFilterConfiguration configuration;

  const CIFilterVideoDetailsPage({super.key, required this.configuration});

  @override
  State<CIFilterVideoDetailsPage> createState() => _CIFilterDetailsPageState();
}

class _CIFilterDetailsPageState extends State<CIFilterVideoDetailsPage> {
  late final CIFilterConfiguration configuration = widget.configuration;
  late final CIVideoPreviewController sourceController;
  var _controllersReady = false;
  static const _assetPath = 'videos/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _prepare().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    sourceController
        .disconnect()
        .then((_) => sourceController.dispose())
        .whenComplete(() => configuration.dispose());
    super.dispose();
  }

  Future<void> _prepare() async {
    sourceController = await CIVideoPreviewController.fromAsset(_assetPath);
    await configuration.prepare();
    await sourceController.connect(configuration);
    _controllersReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.configuration.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...configuration.parameters.map((e) {
              if (e is DataParameter) {
                return BlocProvider(
                  create: (context) => DataBlocCubit(e, configuration),
                  child: DataDropdownButtonWidget(
                    parameter: e,
                  ),
                );
              }
              if (e is ColorParameter) {
                return ColorParameterWidget(
                  parameter: e,
                  onChanged: () async {
                    await e.update(configuration);
                    setState(() {});
                  },
                );
              } else if (e is RangeNumberParameter) {
                return SliderNumberParameterWidget(
                  parameter: e,
                  onChanged: () async {
                    await e.update(configuration);
                    setState(() {});
                  },
                );
              } else if (e is NumberParameter) {
                return NumberParameterWidget(
                  parameter: e,
                  onChanged: () async {
                    await e.update(configuration);
                    setState(() {});
                  },
                );
              } else if (e is PointParameter) {
                return PointParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              } else if (e is SizeParameter) {
                return SizeParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              }
              return const Offstage();
            }),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: _controllersReady
                  ? CIVideoPreview(
                      controller: sourceController,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exportVideo();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _exportVideo() async {
    const asset = _assetPath;
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${asset.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    final processStream = await configuration.exportVideoFile(
      VideoExportConfig(
        AssetInputSource(asset),
        output,
      ),
    );
    await for(final progress in processStream) {
      if (progress.isProcessingCompleted) {
        break;
      }
      /*
      setState(() {
        progressValue = progress;
      });
      */
    }
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }
}
