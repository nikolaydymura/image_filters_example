import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../brightness_contrast_shader_configuration.dart';
import '../pages/filter_group_details.dart';
import '../pages/filters_details.dart';

class ListSupportedFiltersWidget extends StatelessWidget {
  final List<String> items;

  const ListSupportedFiltersWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            child: ListTile(
              title: const Text('Brightness + Contrast'),
              trailing: Icon(
                Icons.navigate_next,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      final configuration =
                          BrightnessContrastShaderConfiguration();
                      return BlocProvider(
                        create: (context) => Image1Cubit(configuration),
                        child: FilterDetailsScreen(
                          filterName: 'Brightness + Contrast',
                          filterConfiguration: configuration,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        if (index == 1) {
          return Card(
            child: ListTile(
              title: const Text('Brightness + Saturation'),
              trailing: Icon(
                Icons.navigate_next,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      final configuration1 = FlutterImageFilters.createFilter(
                        displayName: 'Brightness',
                      );
                      final configuration2 = FlutterImageFilters.createFilter(
                        displayName: 'Saturation',
                      );
                      if (configuration1 == null || configuration2 == null) {
                        throw UnsupportedError('Group not supported');
                      }
                      return FilterGroupDetailsScreen(
                        filterName1: 'Brightness',
                        filterName2: 'Saturation',
                        filterConfiguration1: configuration1,
                        filterConfiguration2: configuration2,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        final item = items[index - 2];

        return Card(
          child: ListTile(
            title: Text(item),
            trailing: Icon(
              Icons.navigate_next,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final configuration =
                        FlutterImageFilters.createFilter(displayName: item);
                    if (configuration == null) {
                      throw UnsupportedError('$item not supported');
                    }
                    return BlocProvider(
                      create: (context) => Image1Cubit(configuration),
                      child: FilterDetailsScreen(
                        filterName: item,
                        filterConfiguration: configuration,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      itemCount: items.length + 2,
    );
  }
}
