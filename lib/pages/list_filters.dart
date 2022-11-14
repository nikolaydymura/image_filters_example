import 'dart:collection';
import 'dart:io';

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

  List<String> get _shaderItems => SplayTreeSet<String>.from(
        [
          ...imf.availableShaders.keys,
        ],
      ).toList();

  List<String> get _ciFilterItems => SplayTreeSet<String>.from(
        [...cif.availableFilters.keys],
      ).toList();

  List<String> get _gpuVideoFilterItems => SplayTreeSet<String>.from(
        [],
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
                      child: Text('Image Shaders'),
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
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(Platform.isIOS ? 'CI Filters' : 'GPUVideo'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  final item = _shaderItems[index];

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
                              imf.availableShaders[item]?.call();
                              if (configuration == null) {
                                throw UnsupportedError('$item not supported');
                              }
                              return BlocProvider(
                                create: (context) =>
                                    Image1Cubit(configuration),
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
                itemCount: _shaderItems.length,
              ),
              if (Platform.isIOS)
                ListView.builder(
                  itemBuilder: (context, index) {
                    final item = _ciFilterItems[index];

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
                                return CIFilterDetailsPage(filterName: item);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: _ciFilterItems.length,
                ),
              if (Platform.isAndroid)
                ListView.builder(
                  itemBuilder: (context, index) {
                    final item = _gpuVideoFilterItems[index];

                    return Card(
                      child: ListTile(
                        title: Text(item),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                  itemCount: _gpuVideoFilterItems.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
