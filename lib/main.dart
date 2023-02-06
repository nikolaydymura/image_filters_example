import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import 'blocs/source_image_bloc/source_image_bloc.dart';
import 'brightness_contrast_shader_configuration.dart';
import 'pages/list_filters.dart';

void main() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(
    () => FragmentProgram.fromAsset('shaders/brightness_contrast.frag'),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SourceImageCubit>(
          create: (context) => SourceImageCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter filters example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        cardColor: Colors.deepPurple[200],
      ),
      home: const FiltersListScreen(),
    );
  }
}
