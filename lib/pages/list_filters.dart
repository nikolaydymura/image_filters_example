import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart' as imf;
import 'package:flutter_core_image_filters/flutter_core_image_filters.dart';

import 'package:flutter_gpu_video_filters/flutter_gpu_video_filters.dart' as gpuf;

import '../widgets/list_supported_filters_widget.dart';
import '../widgets/tabs_widget.dart';
import 'ci_filter_details.dart';
import 'ci_filter_video_details.dart';
import 'gpu_filter_video_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  List<String> get _shaderItems => SplayTreeSet<String>.from(
        [
          ...imf.availableShaders.keys,
        ],
      ).toList();

  List<String> get _ciFilterItems => SplayTreeSet<String>.from(
        [...FlutterCoreImageFilters.availableFilters],
      ).toList();

  List<String> get _gpuVideoFilterItems => SplayTreeSet<String>.from(
        [...gpuf.availableFilters.keys],
      ).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kDebugMode ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Center(child: Text('Available filters')),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              const TabsWidget(outputText: Text('Shader Image')),
              if (kDebugMode || Platform.isIOS)
                const TabsWidget(
                  outputText: Text('Core Image'),
                ),
              if (kDebugMode || Platform.isAndroid)
                const TabsWidget(
                  outputText: Text('GPU Video'),
                ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              ListSupportedFiltersWidget(items: _shaderItems),
              if (kDebugMode || Platform.isIOS)
                ListView.builder(
                  itemBuilder: (context, index) {
                    final item = _ciFilterItems[index];

                    return Card(
                      child: ListTile(
                        title: Text(item),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.video_file_outlined),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CIFilterVideoDetailsPage(filterName: item);
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.image_outlined),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
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
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _ciFilterItems.length,
                ),
              if (kDebugMode || Platform.isAndroid)
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return GPUFilterVideoDetailsPage(filterName: item);
                              },
                            ),
                          );
                        },
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
