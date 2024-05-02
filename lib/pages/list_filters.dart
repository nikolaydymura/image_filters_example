import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import '../blocs/export_bloc/export_cubit.dart';
import '../blocs/screen_index_cubit.dart';
import '../blocs/search_bloc/search_bloc.dart';
import '../brightness_contrast_shader_configuration.dart';
import '../widgets/list_supported_filters_widget.dart';
import 'ci_filter_details.dart';
import 'ci_filter_group_details.dart';
import 'filter_group_details.dart';
import 'filter_video_details.dart';
import 'filters_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ListSupportedFiltersWidget<ShadersBloc>(
        configuration: 'ShaderConfiguration',
        onItemTap: (name) {
          handleImageShaderTap(context, name);
        },
      ),
      ListSupportedFiltersWidget<CIImageBloc>(
        configuration: 'CIFilterConfiguration',
        onItemTap: (name) {
          handleCIImageTap(context, name);
        },
      ),
      ListSupportedFiltersWidget<CIVideoBloc>(
        configuration: 'CIFilterConfiguration',
        onItemTap: (name) {
          handleCIVideoTap(context, name);
        },
      ),
      ListSupportedFiltersWidget<GPUVideoBloc>(
        configuration: 'GPUFilterConfiguration',
        onItemTap: (name) {
          handleGPUVideoTap(context, name);
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: FittedBox(
          child: BlocBuilder<ScreenIndexCubit, int>(
            builder: (context, state) {
              if (state == 0) {
                return const Text('Available Shader filters');
              }
              if (state == 1) {
                return const Text('Available Core Image filters');
              }
              if (state == 2) {
                return const Text('Available Core Image (video) filters');
              }
              return const Text('Available GPU video filters');
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ScreenIndexCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
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
            currentIndex: state,
            onTap: (value) =>
                context.read<ScreenIndexCubit>().updateScreenIndex(value),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ScreenIndexCubit, int>(
          builder: (context, state) {
            return widgetOptions[state];
          },
        ),
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
    if (name == 'Color Monochrome + Color Threshold') {
      final configuration1 = FlutterCoreImageFilters.createFilter(
        displayName: 'Color Monochrome',
      );
      final configuration2 = FlutterCoreImageFilters.createFilter(
        displayName: 'Color Threshold',
      );
      _pushPage(
        context,
        (context) {
          return CIFilterGroupDetailsScreen(
            filterName1: 'Color Monochrome',
            filterName2: 'Color Threshold',
            filterConfiguration1: configuration1,
            filterConfiguration2: configuration2,
          );
        },
      );
    }
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
    } else if (name == 'Lookup + Contrast + Brightness + Exposure') {
      configuration = LookupContrastBrightnessExposureShaderConfiguration();
    } else if (name == 'HALD Lookup + Contrast + Brightness + Exposure') {
      configuration = HALDLookupContrastBrightnessExposureShaderConfiguration();
    } else {
      configuration = FlutterImageFilters.createFilter(displayName: name);
    }
    if (configuration == null) {
      _showWarning(context, '$name not supported');
    } else {
      _pushPage(
        context,
        (context) {
          return FilterDetailsScreen(
            filterName: name,
            filterConfiguration: configuration!,
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
