import 'dart:io';
import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as img;

import '../widgets/color_parameter.dart';
import '../widgets/number_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/slider_number_parameter.dart';

class FilterDetailsScreen extends StatefulWidget {
  final String filterName;

  const FilterDetailsScreen({super.key, required this.filterName});

  @override
  State<FilterDetailsScreen> createState() => _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<FilterDetailsScreen> {
  TextEditingController numController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();
  late final ShaderConfiguration configuration;

  final List<String> luts = [
    'lut/filter_lut_1.png',
    'lut/filter_lut_2.png',
    'lut/filter_lut_3.png',
    'lut/filter_lut_4.png',
    'lut/filter_lut_5.png',
    'lut/filter_lut_6.png',
    'lut/filter_lut_7.png',
    'lut/filter_lut_8.png',
    'lut/filter_lut_9.png',
    'lut/filter_lut_10.png',
    'lut/filter_lut_11.png',
    'lut/filter_lut_12.png',
    'lut/filter_lut_13.png',
  ];
  String dropdownValue = 'lut/filter_lut_1.png';

  @override
  void initState() {
    super.initState();
    final configuration = availableShaders[widget.filterName]?.call();
    if (configuration != null) {
      this.configuration = configuration;
    }
    numController;
    xController;
    yController;
    dropdownValue;
  }

  @override
  void dispose() {
    super.dispose();
    numController.dispose();
    xController.dispose();
    yController.dispose();
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
                return ColorParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              } else if (e is SliderNumberParameter) {
                return SliderNumberParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              } else if (e is NumberParameter) {
                return NumberParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                  controller: numController,
                );
              } else if (e is PointParameter) {
                return PointParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                  xController: xController,
                  yController: yController,
                );
              } else if (e is SizeParameter) {
                return SizeParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                  widthController: xController,
                  heightController: yController,
                );
              }
              return const Offstage();
            }),
            if (configuration is LookupTableShaderConfiguration)
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 8,
                style: TextStyle(color: Theme.of(context).primaryColor),
                underline: Container(
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      dropdownValue = value;
                    });
                  }
                },
                items: luts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(value),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              value.substring(4),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: FutureBuilder(
                future: _textures,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: BeforeAfter(
                        thumbRadius: 0.0,
                        thumbColor: Colors.transparent,
                        beforeImage: ImageShaderPreview(
                          textures: [data.whereType<TextureSource>().first],
                          configuration: NoneShaderConfiguration(),
                        ),
                        afterImage: ImageShaderPreview(
                          textures: data.whereType<TextureSource>(),
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

  Future<Iterable<TextureSource>> get _textures async {
    final textures = <TextureSource>[];
    final source = await TextureSource.fromAsset('images/test.jpg');
    textures.add(source);

    if (configuration is LookupTableShaderConfiguration) {
      final lut = await TextureSource.fromAsset(dropdownValue);
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
