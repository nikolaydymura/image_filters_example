import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart' as imf;
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart'
    as cif;

import '../widgets/list_supported_filters_widget.dart';
import '../widgets/tabs_widget.dart';
import 'ci_filter_details.dart';

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
            tabs: const [
              TabsWidget(outputText: Text('Image Shaders')),
              TabsWidget(
                outputText:
                    Text(/*Platform.isIOS ? 'CI Filters' :*/ 'GPUVideo'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              ListSupportedFiltersWidget(items: _shaderItems),
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
