import 'dart:io';

import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../widgets/image_dropdown_button_widget.dart';
import '../widgets/parameters_container.dart';

class CIFilterDetailsPage extends StatefulWidget {
  final CIFilterConfiguration configuration;

  const CIFilterDetailsPage({super.key, required this.configuration});

  @override
  State<CIFilterDetailsPage> createState() => _CIFilterDetailsPageState();
}

class _CIFilterDetailsPageState extends State<CIFilterDetailsPage> {
  late final CIFilterConfiguration configuration = widget.configuration;
  late CIImagePreviewController sourceController;
  late CIImagePreviewController destinationController;
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
    sourceController = await CIImagePreviewController.initialize();
    destinationController = await CIImagePreviewController.initialize();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                ImageDropdownButtonWidget(),
              ],
            ),
            ...configuration.children((e) async {
              await e.update(configuration);
              setState(() {});
            }),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: _controllersReady
                  ? BlocListener<SourceImageCubit, SourceImageState>(
                      listenWhen: (prev, next) =>
                          prev.selectedIndex != next.selectedIndex,
                      listener: (context, state) {
                        final source = state.selected;
                        sourceController.setImageSource(source);
                        destinationController.setImageSource(source);
                      },
                      child: SizedBox(
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 2,
        ),
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
              tooltip: 'Export as file using swift code',
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
