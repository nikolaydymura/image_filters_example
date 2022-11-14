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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Center(child: Text('Available filters')),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).primaryColorLight,
                        width: 1,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('IMAGE'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).primaryColorLight,
                        width: 1,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('VIDEO'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
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
                                  create: (context) =>
                                      Image1Cubit(configuration),
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
            const Center(
              child: Text(
                'Here are the video filters',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
