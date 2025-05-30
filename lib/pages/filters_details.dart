import 'dart:io';

import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../widgets/image_dropdown_button_widget.dart';
import '../widgets/parameters_container.dart';
import 'take_camera_image.dart';

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
  late final noConfiguration = NoneShaderConfiguration();

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
        title: FittedBox(child: Text(widget.filterName)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePictureScreen()),
              );
            },
            icon: Icon(Icons.camera_alt),
          ),
          ImageDropdownButtonWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...configuration.children((e) {
              e.update(configuration);
              setState(() {});
            }),
            const SizedBox(height: 8.0),
            Expanded(
              child: BlocBuilder<SourceImageCubit, SourceImageState>(
                builder: (context, state) {
                  if (state is SourceImageReady) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.60,
                      ),
                      child: BeforeAfter(
                        thumbRadius: 0.0,
                        thumbColor: Colors.transparent,
                        beforeImage: ImageShaderPreview(
                          texture: state.textureSource,
                          configuration: noConfiguration,
                        ),
                        afterImage: ImageShaderPreview(
                          texture: state.textureSource,
                          configuration: configuration,
                        ),
                      ),
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
        heroTag: null,
        onPressed: () {
          _exportImage();
        },
        tooltip: 'Export as binary data and compress on Flutter side',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _exportImage() async {
    final selectedImage = context.read<SourceImageCubit>().state.selected;
    final TextureSource texture;
    final String extension;
    if (selectedImage is FileInputSource) {
      texture = await TextureSource.fromFile(selectedImage.file);
      extension = selectedImage.file.path.split('.').last;
    } else if (selectedImage is AssetInputSource) {
      texture = await TextureSource.fromAsset(selectedImage.path);
      extension = selectedImage.path.split('.').last;
    } else {
      throw UnsupportedError('Unsupported input source');
    }
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    final watch = Stopwatch();
    watch.start();
    final image = await configuration.export(
      texture,
      texture.size,
    );
    final bytes = await image.toByteData();
    debugPrint(
      'Exporting image took ${watch.elapsedMilliseconds} milliseconds',
    );
    if (bytes == null) {
      throw UnsupportedError('Failed to extract bytes for image');
    }
    final image1 = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: bytes.buffer,
      numChannels: 4,
    );
    if (extension == 'png') {
      await img.encodePngFile(output.path, image1);
    } else {
      await img.encodeJpgFile(output.path, image1);
    }
    debugPrint('Exporting file took ${watch.elapsedMilliseconds} milliseconds');
    debugPrint('Exported: ${output.absolute}');
  }
}
