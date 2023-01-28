import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';

import '../widgets/color_parameter.dart';
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
  late final GPUVideoPreviewController sourceController;
  var _controllersReady = false;

  @override
  void initState() {
    super.initState();
    final configuration = availableFilters[widget.filterName]?.call();
    if (configuration != null) {
      this.configuration = configuration;
    }
    _prepare().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _prepare() async {
    sourceController =
        await GPUVideoPreviewController.fromAsset('videos/BigBuckBunny.mp4');
    await sourceController.connect(configuration);
    _controllersReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...configuration.parameters.map((e) {
              /*if (e is DataParameter) {
                return BlocProvider(
                  create: (context) => DataBlocCubit(e, configuration),
                  child: DataDropdownButtonWidget(
                    parameter: e,
                  ),
                );
              }*/
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
                  ? GPUVideoPreview(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _exportVideo() async {}
}
