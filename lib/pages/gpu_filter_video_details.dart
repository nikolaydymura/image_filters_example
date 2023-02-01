import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';
import 'package:path_provider/path_provider.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';
import '../widgets/color_parameter.dart';
import '../widgets/data_dropdown_button_widget.dart';
import '../widgets/number_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/slider_number_parameter.dart';

class GPUFilterVideoDetailsPage extends StatefulWidget {
  final String filterName;

  const GPUFilterVideoDetailsPage({super.key, required this.filterName});

  @override
  State<GPUFilterVideoDetailsPage> createState() => _GPUFilterDetailsPageState();
}

class _GPUFilterDetailsPageState extends State<GPUFilterVideoDetailsPage> {
  late final GPUFilterConfiguration configuration;
  late final GPUVideoPreviewController sourceController1;
  late final GPUVideoPreviewController sourceController2;
  late final GPUVideoPreviewParams params2;
  late final GPUVideoPreviewController sourceController3;
  static const _assetPath = 'videos/BigBuckBunny.mp4';
  var _controllersReady = false;
  var _paramsReady = false;

  @override
  void initState() {
    super.initState();
    configuration =
        FlutterVideoFilters.createFilter(displayName: widget.filterName);
    if (kDebugMode) {
      _prepare1().whenComplete(() => setState(() {}));
    }
    _prepare2().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      sourceController1.dispose();
    }
    sourceController2.dispose();
  }

  Future<void> _prepare1() async {
    sourceController1 = await GPUVideoPreviewController.fromAsset(_assetPath);
    await sourceController1.connect(configuration);
    _controllersReady = true;
  }

  Future<void> _prepare2() async {
    params2 = await GPUVideoPreviewParams.create(configuration);
    _paramsReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Preview'),
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
            Expanded(
              child: _paramsReady
                  ? GPUVideoNativePreview(
                      params: params2,
                      configuration: configuration,
                      onViewCreated: (controller) {
                        sourceController2 = controller;
                        sourceController2.setVideoAsset(_assetPath);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
/*            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: GPUVideoSurfacePreview(
                onViewCreated: (controller) {
                  sourceController3 = controller;
                  sourceController3.setVideoAsset(_assetPath);
                },
              ),
            ),*/
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: _controllersReady
                  ? GPUVideoTexturePreview(
                      controller: sourceController1,
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
    await for (final progress in processStream) {
      debugPrint('Exporting file ${progress.toInt()}%');
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
