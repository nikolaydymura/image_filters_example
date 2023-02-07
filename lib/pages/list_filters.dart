import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:provider/provider.dart';

import '../blocs/export_bloc/export_cubit.dart';
import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../brightness_contrast_shader_configuration.dart';
import '../widgets/list_supported_filters_widget.dart';
import '../widgets/screen_index_provider.dart';
import 'ci_filter_details.dart';
import 'filter_group_details.dart';
import 'filter_video_details.dart';
import 'filters_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  List<String> get _shaderItems => SplayTreeSet<String>.from(
        FlutterImageFilters.availableFilters,
      ).toList();

  List<String> get _ciImageFilterItems => SplayTreeSet<String>.from(
        FlutterCoreImageFilters.availableImageOnlyFilters,
      ).toList();

  List<String> get _ciVideoFilterItems => SplayTreeSet<String>.from(
        FlutterCoreImageFilters.availableVideoOnlyFilters,
      ).toList();

  List<String> get _gpuVideoFilterItems => SplayTreeSet<String>.from(
        FlutterVideoFilters.availableFilters,
      ).toList();

  @override
  Widget build(BuildContext context) {
    final screenIndexProvider = Provider.of<ScreenIndexProvider>(context);
    final currentScreenIndex = screenIndexProvider.fetchCurrentScreenIndex;
    List<Widget> widgetOptions = <Widget>[
      ListSupportedFiltersWidget(
        items: _shaderItems,
        configuration: 'ShaderConfiguration',
        onItemTap: (name) {
          handleImageShaderTap(context, name);
        },
      ),
      ListSupportedFiltersWidget(
        items: _ciImageFilterItems,
        configuration: 'CIFilterConfiguration',
        onItemTap: (name) {
          handleCIImageTap(context, name);
        },
      ),
      ListSupportedFiltersWidget(
        items: _ciVideoFilterItems,
        configuration: 'CIFilterConfiguration',
        onItemTap: (name) {
          handleCIVideoTap(context, name);
        },
      ),
      ListSupportedFiltersWidget(
        items: _gpuVideoFilterItems,
        configuration: 'GPUFilterConfiguration',
        onItemTap: (name) {
          handleGPUVideoTap(context, name);
        },
      ),
    ];
    int selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Center(child: Text('Available filters')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        elevation: 1.5,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Shaders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Core Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'Core Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'GPU Video',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (value) => screenIndexProvider.updateScreenIndex(value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widgetOptions[currentScreenIndex],
      ),
    );
  }
}

extension on FiltersListScreen {
  void handleGPUVideoTap(BuildContext context, String name) {
    _pushPage(
      context,
      (context) {
        return BlocProvider(
          create: (context) => ExportCubit(),
          child: VideoDetailsPage(
            filterName: name,
            gpu: true,
          ),
        );
      },
    );
  }

  void handleCIVideoTap(BuildContext context, String name) {
    final configuration = FlutterCoreImageFilters.createFilter(
      displayName: name,
    );
    if (configuration.categories.contains(CICategory.video) &&
        configuration.hasInputImage) {
      _pushPage(
        context,
        (context) {
          return BlocProvider(
            create: (context) => ExportCubit(),
            child: VideoDetailsPage(
              filterName: name,
              gpu: false,
            ),
          );
        },
      );
    } else {
      _showWarning(context, 'Video processing is unavailable for `$name`');
    }
  }

  void handleCIImageTap(BuildContext context, String name) {
    final configuration = FlutterCoreImageFilters.createFilter(
      displayName: name,
    );
    if (configuration.categories.contains(CICategory.stillImage) &&
        configuration.hasInputImage) {
      _pushPage(
        context,
        (context) {
          return CIFilterDetailsPage(
            configuration: configuration,
          );
        },
      );
    } else {
      _showWarning(context, 'Image processing is unavailable for `$name`');
    }
  }

  void handleImageShaderTap(BuildContext context, String name) {
    if (name == 'Brightness + Saturation') {
      final configuration1 = FlutterImageFilters.createFilter(
        displayName: 'Brightness',
      );
      final configuration2 = FlutterImageFilters.createFilter(
        displayName: 'Saturation',
      );
      if (configuration1 == null || configuration2 == null) {
        _showWarning(context, 'Group not supported');
      } else {
        _pushPage(
          context,
          (context) {
            return FilterGroupDetailsScreen(
              filterName1: 'Brightness',
              filterName2: 'Saturation',
              filterConfiguration1: configuration1,
              filterConfiguration2: configuration2,
            );
          },
        );
      }
      return;
    }
    ShaderConfiguration? configuration;
    if (name == 'Brightness + Contrast') {
      configuration = BrightnessContrastShaderConfiguration();
    } else {
      configuration = FlutterImageFilters.createFilter(displayName: name);
    }
    if (configuration == null) {
      _showWarning(context, '$name not supported');
    } else {
      _pushPage(
        context,
        (context) {
          return BlocProvider(
            create: (context) => Image1Cubit(configuration!),
            child: FilterDetailsScreen(
              filterName: name,
              filterConfiguration: configuration!,
            ),
          );
        },
      );
    }
  }

  void _showWarning(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _pushPage(BuildContext context, Widget Function(BuildContext) builder) {
    Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
