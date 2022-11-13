import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart' as imf;
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart'
    as cif;

import '../blocs/source_image_bloc/source_image_bloc.dart';
import 'ci_filter_details.dart';
import 'filters_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  List<String> get _items => SplayTreeSet<String>.from(
        [...imf.availableShaders.keys, ...cif.availableFilters.keys],
      ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Available filters')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final item = _items[index];

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
                        if (imf.availableShaders.containsKey(item)) {
                          final configuration =
                              imf.availableShaders[item]!.call();
                          return BlocProvider(
                            create: (context) => Image1Bloc(configuration),
                            child: FilterDetailsScreen(
                              filterName: item,
                              filterConfiguration: configuration,
                            ),
                          );
                        }
                        return CIFilterDetailsPage(filterName: item);
                      },
                    ),
                  );
                },
              ),
            );
          },
          itemCount: _items.length,
        ),
      ),
    );
  }
}
