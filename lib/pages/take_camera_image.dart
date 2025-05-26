import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription camera;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    final cameras = await availableCameras();

    camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
    _isCameraReady = true;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isCameraReady
              ? FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
              : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (context.mounted) {
              context.read<SourceImageCubit>().loadFile(image: image);
              Navigator.pop(context);
            }
          } catch (e, t) {
            debugPrint('Error taking picture: $e');
            debugPrintStack(stackTrace: t);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
