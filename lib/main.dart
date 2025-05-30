import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:provider/provider.dart';

import 'blocs/screen_index_cubit.dart';
import 'blocs/search_bloc/search_bloc.dart';
import 'blocs/source_image_bloc/source_image_bloc.dart';
import 'blocs/source_video_bloc/source_video_bloc.dart';
import 'brightness_contrast_shader_configuration.dart';
import 'pages/list_filters.dart';

void main() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(
    () => FragmentProgram.fromAsset('shaders/brightness_contrast.frag'),
  );
  FlutterImageFilters.register<
    LookupContrastBrightnessExposureShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/lookup_contrast_brightness_exposure.frag',
    ),
  );
  FlutterImageFilters.register<
    HALDLookupContrastBrightnessExposureShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/hald_lookup_contrast_brightness_exposure.frag',
    ),
  );
  FlutterImageFilters.register<
    WhiteBalanceExposureContrastSaturationShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/white_balance_exposure_contrast_saturation.frag',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<SourceImageCubit>(create: (context) => SourceImageCubit()),
        BlocProvider<SourceVideoCubit>(create: (context) => SourceVideoCubit()),
        BlocProvider<ScreenIndexCubit>(create: (context) => ScreenIndexCubit()),
        BlocProvider<ShadersBloc>(
          create: (context) => SearchBloc(FlutterImageFilters.availableFilters),
        ),
        BlocProvider<CIImageBloc>(
          create:
              (context) =>
                  SearchBloc(FlutterCoreImageFilters.availableImageOnlyFilters),
        ),
        BlocProvider<CIVideoBloc>(
          create:
              (context) =>
                  SearchBloc(FlutterCoreImageFilters.availableVideoOnlyFilters),
        ),
        BlocProvider<GPUVideoBloc>(
          create: (context) => SearchBloc(FlutterVideoFilters.availableFilters),
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
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        //appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurpleAccent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple[200],
          backgroundColor: Colors.deepPurpleAccent[100],
        ),
        inputDecorationTheme: InputDecorationTheme(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(Colors.deepPurple[200]!.toARGB32()),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(Colors.deepPurple[200]!.toARGB32()),
            ),
          ),
        ),
        cardTheme: CardTheme(color: Colors.deepPurple[200]),
      ),
      home: const FiltersListScreen(),
    );
  }
}
