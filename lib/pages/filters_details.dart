import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as img;

class FilterDetailsScreen extends StatefulWidget {
  const FilterDetailsScreen({super.key});

  @override
  State<FilterDetailsScreen> createState() => _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<FilterDetailsScreen> {
  late final ShaderConfiguration configuration;

  @override
  void initState() {
    super.initState();
    configuration = MonochromeShaderConfiguration()
      ..intensity = 0.5
      ..color = Colors.red;
    _exportImage();
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
        [texture], Size(texture.width.toDouble(), texture.height.toDouble()));
    final bytes = await image.toByteData();
    debugPrint(
        'Exporting image took ${watch.elapsedMilliseconds} milliseconds');
    if (bytes == null) {
      throw UnsupportedError('Failed to extract bytes for image');
    }
    final image1 = img.Image.fromBytes(
        image.width, image.height, bytes.buffer.asUint8List());
    img.JpegEncoder encoder = img.JpegEncoder();
    final data = encoder.encodeImage(image1);
    await output.writeAsBytes(data);
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...configuration.parameters.map((e) {
              if (e is ColorParameter) {
                //e.value = Colors.blue;
                //e.update(configuration);
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    '${e.displayName} ::: ${e.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else if (e is NumberParameter) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${e.displayName} ::: ${e.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const Offstage();
            }),
            Expanded(
                child: FutureBuilder(
              future: TextureSource.fromAsset('images/test.jpg'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ImageShaderPreview(
                      textures: [snapshot.data].whereType<TextureSource>(),
                      configuration: configuration);
                }
                return const Center(child: CircularProgressIndicator());
              },
            )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
