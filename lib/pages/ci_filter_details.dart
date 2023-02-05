import 'dart:io';

import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';
import '../widgets/color_parameter.dart';
import '../widgets/data_dropdown_button_widget.dart';
import '../widgets/number_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/rect_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/slider_number_parameter.dart';

class CIFilterDetailsPage extends StatefulWidget {
  final CIFilterConfiguration configuration;

  const CIFilterDetailsPage({super.key, required this.configuration});

  @override
  State<CIFilterDetailsPage> createState() => _CIFilterDetailsPageState();
}

class _CIFilterDetailsPageState extends State<CIFilterDetailsPage> {
  late final CIFilterConfiguration configuration = widget.configuration;
  late final CIImagePreviewController sourceController;
  late final CIImagePreviewController destinationController;
  var _controllersReady = false;
  static const _assetPath = 'images/inputImage1.jpg';

  @override
  void initState() {
    super.initState();
    _prepare().whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    configuration.dispose();
    super.dispose();
  }

  Future<void> _prepare() async {
    sourceController = await CIImagePreviewController.fromAsset(_assetPath);
    destinationController =
        await CIImagePreviewController.fromAsset(_assetPath);
    await configuration.prepare();
    await destinationController.connect(configuration);
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
              } else if (e is RectParameter) {
                return RectParameterWidget(
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
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.61,
                      child: BeforeAfter(
                        thumbRadius: 0.0,
                        thumbColor: Colors.transparent,
                        beforeImage: CIImagePreview(
                          controller: sourceController,
                        ),
                        afterImage: CIImagePreview(
                          controller: destinationController,
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                _exportImage();
              },
              tooltip: 'Export as binary data and compress on Flutter side',
              child: const Icon(Icons.save),
            ),
            FloatingActionButton(
              heroTag: null,
              tooltip: 'Export as file using swift coce',
              onPressed: () {
                _exportNativeImage();
              },
              child: const Icon(Icons.save_as),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _exportImage() async {
    const asset = _assetPath;
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${asset.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    final image = await configuration.export(
      AssetInputSource(asset),
      format: ImageExportFormat.jpeg,
    );
    final bytes = await image.toByteData();
    debugPrint(
      'Exporting image took ${watch.elapsedMilliseconds} milliseconds',
    );
    if (bytes == null) {
      throw UnsupportedError('Failed to extract bytes for image');
    }
    final image1 = img.Image.fromBytes(
      image.width,
      image.height,
      bytes.buffer.asUint8List(),
    );
    img.JpegEncoder encoder = img.JpegEncoder();
    final data = encoder.encodeImage(image1);
    await output.writeAsBytes(data);
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }

  Future<void> _exportNativeImage() async {
    const asset = _assetPath;
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${asset.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    await configuration.exportImageFile(
      ImageExportConfig(
        AssetInputSource(asset),
        output,
        format: ImageExportFormat.jpeg,
      ),
    );
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }
}
