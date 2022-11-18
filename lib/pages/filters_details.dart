import 'dart:io';
import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as img;

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../models/lut.dart';
import '../widgets/color_parameter.dart';
import '../widgets/image_dropdown_button_widget.dart';
import '../widgets/number_parameter.dart';
import '../widgets/size_parameter.dart';
import '../widgets/point_parameter.dart';
import '../widgets/slider_number_parameter.dart';

class FilterDetailsScreen extends StatefulWidget {
  final String filterName;
  final ShaderConfiguration filterConfiguration;

  const FilterDetailsScreen({
    super.key,
    required this.filterName,
    required this.filterConfiguration,
  });

  @override
  State<FilterDetailsScreen> createState() => _FilterDetailsScreenState();
}

class _FilterDetailsScreenState extends State<FilterDetailsScreen> {
  ShaderConfiguration get configuration => widget.filterConfiguration;

  bool get displayParameters => configuration is LookupTableShaderConfiguration;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...configuration.parameters.where((element) {
              if (configuration is LookupTableShaderConfiguration) {
                if (element.name == 'inputIntensity') {
                  return true;
                }
                return false;
              }
              return true;
            }).map((e) {
              if (e is ColorParameter) {
                return ColorParameterWidget(
                  parameter: e,
                  onChanged: () {
                    setState(() {
                      e.update(configuration);
                    });
                  },
                );
              } else if (e is RangeNumberParameter) {
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
            BlocSelector<Image1Cubit, SourceImageState,
                AdditionalSourceImageState<Lut>?>(
              selector: (state) {
                if (state is AdditionalSourceImageState<Lut>) {
                  return state;
                }
                return null;
              },
              builder: (context, state) {
                if (state != null) {
                  return ImageDropdownButtonWidget(
                    state: state,
                    onChanged: (value) {
                      context.read<Image1Cubit>().changeImage(value);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: BlocBuilder<SourceImageCubit, SourceImageState>(
                builder: (context, state) {
                  if (state is SourceImageReady) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: BeforeAfter(
                        thumbRadius: 0.0,
                        thumbColor: Colors.transparent,
                        beforeImage: ImageShaderPreview(
                          textures: [state.textureSource],
                          configuration: NoneShaderConfiguration(),
                        ),
                        afterImage: BlocBuilder<Image1Cubit, SourceImageState>(
                          builder: (context, textureState) {
                            if (textureState is SourceImageReady) {
                              return ImageShaderPreview(
                                textures: [
                                  state.textureSource,
                                  textureState.textureSource
                                ],
                                configuration: configuration,
                              );
                            } else if (textureState is ImageEmpty) {
                              return ImageShaderPreview(
                                textures: [state.textureSource],
                                configuration: configuration,
                              );
                            } else {
                              return Container();
                            }
                          },
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
