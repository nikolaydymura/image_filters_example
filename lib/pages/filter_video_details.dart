import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

import '../blocs/source_video_bloc/source_video_bloc.dart';
import '../brightness_contrast_filter_configuration.dart';
import '../widgets/export_video_button.dart';
import '../widgets/parameters_container.dart';
import '../widgets/video_dropdown_button_widget.dart';

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
  late final GPUVideoPreviewParams previewParams;

  @override
  bool get previewAvailable => Platform.isAndroid;

  @override
  String get title => configuration.name;

  @override
  Future<void> prepare(PathInputSource source) async {
    previewParams = await GPUVideoPreviewParams.create(configuration);
    _previewReady = previewAvailable;
  }

  @override
  Widget get playerView => GPUVideoNativePreview(
        params: previewParams,
        configuration: configuration,
        onViewCreated: (controller, outputSizeStream) async {
          this.controller = controller;
          await this
              .controller
              .setVideoSource(context.read<SourceVideoCubit>().state.selected);
          await for (final _ in outputSizeStream) {
            setState(() {});
          }
        },
      );

  @override
  GPUFilterConfiguration createConfiguration() {
    if (widget.filterName == 'Brightness + Contrast') {
      return BrightnessContrastFilterConfiguration();
    }
    if (widget.filterName == 'SquareLookupTable + Brightness + Contrast + Exposure') {
      return LookupContrastBrightnessExposureFilterConfiguration();
    }
    return FlutterVideoFilters.createFilter(displayName: widget.filterName);
  }
}

class _CIVideoDetailsBodyState extends State<_CIVideoDetailsBody>
    with _VideoDetailsPageState<CIFilterConfiguration, _CIVideoDetailsBody> {
  @override
  bool get previewAvailable => Platform.isIOS || Platform.isMacOS;

  @override
  String get title => configuration.name;

  @override
  Future<void> prepare(PathInputSource source) async {
    controller = await CIVideoPreviewController.initialize();
    await controller.setVideoSource(source);
    await configuration.prepare();
    await controller.connect(configuration);
    _previewReady = previewAvailable;
  }

  @override
  Widget get playerView => VideoPreview(
        controller: controller,
      );

  @override
  CIFilterConfiguration createConfiguration() =>
      FlutterCoreImageFilters.createFilter(displayName: widget.filterName);
}

mixin _VideoDetailsPageState<F extends VideoFilterConfiguration,
    T extends StatefulWidget> on State<T> {
  var _previewReady = false;

  late final VideoPreviewController controller;
  late final F configuration;

  F createConfiguration();

  bool get previewAvailable;

  String get title;

  Future<void> prepare(PathInputSource source);

  Future<void> release() async {
    await controller.disconnect();
    await controller.dispose();
    await configuration.dispose();
  }

  Widget get playerView;

  @override
  void initState() {
    super.initState();
    configuration = createConfiguration();
    final source = context.read<SourceVideoCubit>().state.selected;
    if (previewAvailable) {
      prepare(source).whenComplete(() => setState(() {}));
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
        title: FittedBox(child: Text(title)),
        actions: const [
          VideoDropdownButtonWidget(),
        ],
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
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocConsumer<SourceVideoCubit, SourceVideoState>(
                  listener: (prev, next) {
                    controller.setVideoSource(next.selected);
                  },
                  builder: (context, state) {
                    return ExportVideoButton(
                      sourceBuilder: () => state.selected,
                      configuration: configuration,
                    );
                  },
                ),
              ],
            )
          : null,
    );
  }
}
