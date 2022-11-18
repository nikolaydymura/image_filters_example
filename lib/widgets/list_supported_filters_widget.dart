import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

import '../blocs/source_image_bloc/source_image_bloc.dart';
import '../pages/filters_details.dart';

class ListSupportedFiltersWidget extends StatelessWidget {
  final List<String> items;
  const ListSupportedFiltersWidget({super.key, required this.items});

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final configuration = FlutterImageFilters.createFilter(displayName: item);
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
      itemCount: items.length,
    );
  }
}
