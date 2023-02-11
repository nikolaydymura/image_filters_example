import 'dart:io';

import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../blocs/source_image_shader_bloc/source_image_shader_bloc.dart';
import '../widgets/parameters_container.dart';

class FilterGroupDetailsScreen extends StatefulWidget {
  final String filterName1;
  final String filterName2;
  final ShaderConfiguration filterConfiguration1;
  final ShaderConfiguration filterConfiguration2;

  const FilterGroupDetailsScreen({
    super.key,
    required this.filterName1,
    required this.filterName2,
    required this.filterConfiguration1,
    required this.filterConfiguration2,
  });

  @override
  State<FilterGroupDetailsScreen> createState() => _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<FilterGroupDetailsScreen> {
  late GroupShaderConfiguration configuration;

  @override
  void initState() {
    super.initState();
    configuration = GroupShaderConfiguration();
    configuration.add(widget.filterConfiguration1);
    configuration.add(widget.filterConfiguration2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.filterName1} + ${widget.filterName2}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.filterName1),
            ...widget.filterConfiguration1.children((e) {
              e.update(widget.filterConfiguration1);
              setState(() {});
            }),
            const Divider(height: 4),
            Text(widget.filterName2),
            ...widget.filterConfiguration2.children((e) {
              e.update(widget.filterConfiguration2);
              setState(() {});
            }),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child:
                  BlocBuilder<SourceImageShaderCubit, SourceImageShaderState>(
                builder: (context, state) {
                  if (state is SourceImageShaderReady) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: BeforeAfter(
                        thumbRadius: 0.0,
                        thumbColor: Colors.transparent,
                        beforeImage: ImageShaderPreview(
                          texture: state.textureSource,
                          configuration: NoneShaderConfiguration(),
                        ),
                        afterImage: PipelineImageShaderPreview(
                          texture: state.textureSource,
                          configuration: configuration,
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exportImage();
        },
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _exportImage() async {
    const asset = 'images/inputImage.jpg';
    final texture = await TextureSource.fromAsset(asset);
    final directory = await getTemporaryDirectory();
    final output =
        File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final watch = Stopwatch();
    watch.start();
    final image = await configuration.export(
      texture,
      Size(texture.width.toDouble(), texture.height.toDouble()),
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
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextureSource texture;
  late GroupShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = GroupShaderConfiguration();
    configuration.add(BrightnessShaderConfiguration()..brightness = 0.5);
    configuration.add(SaturationShaderConfiguration()..saturation = 0.5);
    TextureSource.fromAsset('demo.jpeg')
        .then((value) => texture = value)
        .whenComplete(
          () => setState(() {
            textureLoaded = true;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return textureLoaded
        ? PipelineImageShaderPreview(
            texture: texture,
            configuration: configuration,
          )
        : const Offstage();
  }
}
