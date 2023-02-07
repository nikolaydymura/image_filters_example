import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';
import '../widgets/color_parameter.dart';
import '../widgets/data_dropdown_button_widget.dart';
import '../widgets/export_video_button.dart';
import '../widgets/number_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/rect_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/slider_number_parameter.dart';
import '../widgets/vector_parameter.dart';

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
        onViewCreated: (controller) {
          this.controller = controller;
          this.controller.setVideoAsset(_VideoDetailsPageState._assetPath);
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
    final numbers = configuration.parameters
        .whereType<NumberParameter>()
        .whereNot((e) => e is RangeNumberParameter);
    final datas = configuration.parameters.whereType<DataParameter>();
    final params = configuration.parameters
        .whereNot((e) => e is NumberParameter && e is! RangeNumberParameter)
        .whereNot((e) => e is DataParameter);
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
            if (numbers.isNotEmpty || datas.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  ...numbers.map(
                    (e) => NumberParameterWidget(
                      parameter: e,
                      onChanged: () async {
                        await e.update(configuration);
                        setState(() {});
                      },
                    ),
                  ),
                  ...datas.map(
                        (e) => BlocProvider(
                      create: (context) => DataBlocCubit(e, configuration),
                      child: DataDropdownButtonWidget(
                        parameter: e,
                      ),
                    ),
                  )
                ],
              ),
            ...params.map((e) {
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
              } else if (e is RectParameter) {
                return RectParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              } else if (e is VectorParameter) {
                return VectorParameterWidget(
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
