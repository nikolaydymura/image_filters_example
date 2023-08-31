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

class CIFilterGroupDetailsScreen extends StatefulWidget {
  final String filterName1;
  final String filterName2;
  final CIFilterConfiguration filterConfiguration1;
  final CIFilterConfiguration filterConfiguration2;

  const CIFilterGroupDetailsScreen({
    super.key,
    required this.filterName1,
    required this.filterName2,
    required this.filterConfiguration1,
    required this.filterConfiguration2,
  });

  @override
  State<CIFilterGroupDetailsScreen> createState() =>
      _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<CIFilterGroupDetailsScreen> {
  late GroupCIFilterConfiguration configuration;
  late CIImagePreviewController sourceController;
  late CIImagePreviewController destinationController;
  var _controllersReady = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SourceImageCubit>();
    _prepare(cubit).whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    configuration.dispose();
    super.dispose();
  }

  Future<void> _prepare(SourceImageCubit cubit) async {
    configuration = GroupCIFilterConfiguration(
      [widget.filterConfiguration1, widget.filterConfiguration2],
    );
    sourceController = await CIImagePreviewController.initialize();
    await sourceController.setImageSource(cubit.state.selected);
    destinationController = await CIImagePreviewController.initialize();
    await destinationController.setImageSource(cubit.state.selected);
    await configuration.prepare();
    await destinationController.connect(configuration);
    _controllersReady = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text('${widget.filterName1} + ${widget.filterName2}'),
        ),
        actions: const [
          ImageDropdownButtonWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.filterName1),
            ...widget.filterConfiguration1.children((e) async {
              await e.update(widget.filterConfiguration1);
              setState(() {});
            }),
            const Divider(height: 4),
            Text(widget.filterName2),
            ...widget.filterConfiguration2.children((e) async {
              await e.update(widget.filterConfiguration2);
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
    final source =
        context.read<SourceImageCubit>().state.selected as PathInputSource;
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${source.path.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    final image = await configuration.export(
      source,
      format: ImageExportFormat.jpeg,
    );
    final bytes = await image.toByteData();
    debugPrint(
      'Exporting image took ${watch.elapsedMilliseconds} milliseconds',
    );
    if (bytes == null) {
      throw UnsupportedError('Failed to extract bytes for image');
    }
    final persistedImage = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: bytes.buffer,
      numChannels: 4,
    );
    img.JpegEncoder encoder = img.JpegEncoder();
    final data = encoder.encode(persistedImage);
    await output.writeAsBytes(data);
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }

  Future<void> _exportNativeImage() async {
    final source =
        context.read<SourceImageCubit>().state.selected as PathInputSource;
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${source.path.split('.').last}',
    );
    final watch = Stopwatch();
    watch.start();
    await configuration.exportImageFile(
      ImageExportConfig(
        source,
        output,
        format: ImageExportFormat.jpeg,
      ),
    );
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }
}
