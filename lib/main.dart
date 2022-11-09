import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...configuration.parameters.map((e) {
              if (e is ColorParameter) {
                //e.value = Colors.blue;
                //e.update(configuration);
                return Text('${e.displayName} ::: ${e.value}');
              } else if (e is NumberParameter) {
                return Text('${e.displayName} ::: ${e.value}');
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
                return const CircularProgressIndicator();
              },
            )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
