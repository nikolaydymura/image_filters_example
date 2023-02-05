import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class GPUFilterVideoDetailsPage extends StatefulWidget {
  final String filterName;

  const GPUFilterVideoDetailsPage({super.key, required this.filterName});

  @override
  State<GPUFilterVideoDetailsPage> createState() =>
      _GPUFilterDetailsPageState();
}

class _GPUFilterDetailsPageState extends State<GPUFilterVideoDetailsPage> {
  late final GPUFilterConfiguration configuration;
  late final GPUVideoPreviewController controller;
  late final GPUVideoPreviewParams previewParams;
  static const _assetPath = 'videos/BigBuckBunny.mp4';
  var _paramsReady = false;

  @override
  void initState() {
    super.initState();
    configuration =
        FlutterVideoFilters.createFilter(displayName: widget.filterName);
    _prepare().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> _prepare() async {
    previewParams = await GPUVideoPreviewParams.create(configuration);
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
              child: _paramsReady
                  ? GPUVideoNativePreview(
                      params: previewParams,
                      configuration: configuration,
                      onViewCreated: (controller) {
                        this.controller = controller;
                        this.controller.setVideoAsset(_assetPath);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: ExportVideoButton(
        sourceBuilder: () => AssetInputSource(_assetPath),
        configuration: configuration,
      ),
    );
  }
}
