import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as img;

class FilterDetailsScreen extends StatefulWidget {
  final String filterName;

  const FilterDetailsScreen({super.key, required this.filterName});

  @override
  State<FilterDetailsScreen> createState() => _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<FilterDetailsScreen> {
  late final ShaderConfiguration configuration;

  @override
  void initState() {
    super.initState();
    final configuration = availableShaders[widget.filterName]?.call();
    if (configuration != null) {
      this.configuration = configuration;
    }
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
              if (e is ColorParameter) {
                //e.value = Colors.blue;
                //e.update(configuration);
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        e.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: e.value.toString()),
                      ),
                    )
                  ],
                );
              } else if (e is SliderNumberParameter) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        e.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: e.value.toDouble(),
                        max: e.max?.toDouble() ?? double.infinity,
                        min: e.min?.toDouble() ?? double.minPositive,
                        onChanged: (double value) {},
                      ),
                    )
                  ],
                );
              } else if (e is NumberParameter) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        e.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: e.value.toString()),
                      ),
                    )
                  ],
                );
              }
              return const Offstage();
            }),
            Expanded(
              child: FutureBuilder(
                future: _textures,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return ImageShaderPreview(
                      textures: data.whereType<TextureSource>(),
                      configuration: configuration,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
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

  Future<Iterable<TextureSource>> get _textures async {
    final textures = <TextureSource>[];
    final source = await TextureSource.fromAsset('images/test.jpg');
    textures.add(source);
    if (configuration is LookupTableShaderConfiguration) {
      final lut = await TextureSource.fromAsset('lut/filter_lut_1.png');
      textures.add(lut);
    }
    return textures;
  }

  Future<void> _exportImage() async {
    const asset = 'images/test.jpg';
    final texture = await TextureSource.fromAsset(asset);
    final directory = await getTemporaryDirectory();
    final output =
        File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final watch = Stopwatch();
    watch.start();
    final image = await configuration.exportImage(
      [texture],
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
