import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

import '../widgets/export_video_button.dart';
import '../widgets/parameters_container.dart';

class VideoDetailsPage extends StatelessWidget {
  final String filterName;
  final bool gpu;

  const VideoDetailsPage({
    super.key,
    required this.filterName,
    required this.gpu,
  });

  @override
  Widget build(BuildContext context) {
    return gpu
        ? _GPUVideoDetailsBody(filterName: filterName)
        : _CIVideoDetailsBody(filterName: filterName);
  }
}

class _GPUVideoDetailsBody extends StatefulWidget {
  final String filterName;

  _GPUVideoDetailsBody({required this.filterName})
      : super(key: ValueKey(filterName));

  @override
  State<StatefulWidget> createState() => _GPUVideoDetailsBodyState();
}

class _CIVideoDetailsBody extends StatefulWidget {
  final String filterName;

  _CIVideoDetailsBody({required this.filterName})
      : super(key: ValueKey(filterName));

  @override
  State<StatefulWidget> createState() => _CIVideoDetailsBodyState();
}

class _GPUVideoDetailsBodyState extends State<_GPUVideoDetailsBody>
    with _VideoDetailsPageState<GPUFilterConfiguration, _GPUVideoDetailsBody> {
  late final GPUVideoPreviewController controller;
  late final GPUVideoPreviewParams previewParams;

  @override
  bool get previewAvailable => Platform.isAndroid;

  @override
  String get title => configuration.name;

  @override
  Future<void> release() async {
    await controller.dispose();
    await configuration.dispose();
  }

  @override
  Future<void> prepare() async {
    previewParams = await GPUVideoPreviewParams.create(configuration);
    _previewReady = previewAvailable;
  }

  @override
  Widget get playerView => GPUVideoNativePreview(
        params: previewParams,
        configuration: configuration,
        onViewCreated: (controller, outputSizeStream) async {
          this.controller = controller;
          this.controller.setVideoAsset(_VideoDetailsPageState._assetPath);
          await for (final _ in outputSizeStream) {
            setState(() {});
          }
        },
      );

  @override
  GPUFilterConfiguration createConfiguration() =>
      FlutterVideoFilters.createFilter(displayName: widget.filterName);
}

class _CIVideoDetailsBodyState extends State<_CIVideoDetailsBody>
    with _VideoDetailsPageState<CIFilterConfiguration, _CIVideoDetailsBody> {
  late final CIVideoPreviewController controller;

  @override
  bool get previewAvailable => Platform.isIOS || Platform.isMacOS;

  @override
  String get title => configuration.name;

  @override
  Future<void> release() async {
    await controller.disconnect();
    await controller.dispose();
    await configuration.dispose();
  }

  @override
  Future<void> prepare() async {
    controller = await CIVideoPreviewController.fromAsset(
      _VideoDetailsPageState._assetPath,
    );
    await configuration.prepare();
    await controller.connect(configuration);
    _previewReady = previewAvailable;
  }

  @override
  Widget get playerView => CIVideoPreview(
        controller: controller,
      );

  @override
  CIFilterConfiguration createConfiguration() =>
      FlutterCoreImageFilters.createFilter(displayName: widget.filterName);
}

mixin _VideoDetailsPageState<F extends VideoFilterConfiguration,
    T extends StatefulWidget> on State<T> {
  static const _assetPath = 'videos/BigBuckBunny.mp4';
  var _previewReady = false;

  late final F configuration;

  F createConfiguration();

  bool get previewAvailable;

  String get title;

  Future<void> prepare();

  Future<void> release();

  Widget get playerView;

  @override
  void initState() {
    super.initState();
    configuration = createConfiguration();
    if (previewAvailable) {
      prepare().whenComplete(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    if (previewAvailable && _previewReady) {
      release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...configuration.children((e) async {
              await e.update(configuration);
              setState(() {});
            }),
            Expanded(
              child: _previewReady
                  ? playerView
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: previewAvailable
          ? ExportVideoButton(
              sourceBuilder: () => AssetInputSource(_assetPath),
              configuration: configuration,
            )
          : null,
    );
  }
}
