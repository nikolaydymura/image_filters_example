import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../brightness_contrast_shader_configuration.dart';
import '../pages/filter_group_details.dart';
import '../pages/filters_details.dart';

class ListSupportedFiltersWidget extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTap;

  const ListSupportedFiltersWidget({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          child: ListTile(
            title: Text(item),
            trailing: Icon(
              Icons.navigate_next,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              onItemTap(item);
            },
          ),
        );
      },
      itemCount: items.length,
    );
  }
}
