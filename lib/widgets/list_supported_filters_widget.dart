import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_bloc/search_bloc.dart';

class ListSupportedFiltersWidget extends StatelessWidget {
  final String configuration;
  final List<String> items;
  final Function(String) onItemTap;

  const ListSupportedFiltersWidget({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> favorites = {
      'CIFilterConfiguration': [
        'Color Cube',
        'Color Cubes Mixed With Mask',
        'Color Cube with ColorSpace',
        'Color Monochrome',
        'Lookup Table',
      ],
      'GPUFilterConfiguration': [
        'HALD Lookup Table',
        'Monochrome',
        'Square Lookup Table',
      ],
      'ShaderConfiguration': [
        'Brightness + Contrast',
        'Brightness + Saturation',
        'HALD Lookup Table',
        'Monochrome',
        'Square Lookup Table',
      ],
    };
    final List<String> filters = favorites[configuration] ?? [];
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.94,
          height: 54.0,
          child: TextField(
            onChanged: (value) =>
                context.read<SearchBloc>().search(items, value),
            decoration: InputDecoration(
              prefix: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_outlined),
              ),
              fillColor: Theme.of(context).cardColor,
              hintText: 'Search',
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchEmpty) {
                return const Center(
                  child: Text(
                    'Founded nothing',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              } else if (state is SearchSucceeded) {
                return CustomScrollView(
                  slivers: [
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.items[index];
                          return Card(
                            color: Colors.greenAccent[200],
                            child: ListTile(
                              trailing: const Icon(
                                Icons.navigate_next,
                              ),
                              title: Text(
                                item,
                              ),
                              onTap: () {
                                onItemTap(item);
                              },
                            ),
                          );
                        },
                        childCount: state.items.length, // 1000 list items
                      ),
                      itemExtent: 64,
                    ),
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.items[index];
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
                        childCount: state.items.length,
                      ),
                      itemExtent: 64,
                    )
                  ],
                );
              } else if (state is SearchInitial) {
                return CustomScrollView(
                  slivers: [
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (state is SearchEmpty) {
                            return const Center(
                              child: Text(
                                'Founded nothing',
                                style: TextStyle(fontSize: 24),
                              ),
                            );
                          }
                          final item = filters[index];
                          return Card(
                            color: Colors.greenAccent[200],
                            child: ListTile(
                              trailing: const Icon(
                                Icons.navigate_next,
                              ),
                              title: Text(
                                item,
                              ),
                              onTap: () {
                                onItemTap(item);
                              },
                            ),
                          );
                        },
                        childCount: filters.length, // 1000 list items
                      ),
                      itemExtent: 64,
                    ),
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
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
                        childCount: items.length,
                      ),
                      itemExtent: 64,
                    )
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        /*Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchEmpty) {
                return const Center(
                  child: Text(
                    'Founded nothing',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }
              if (state is SearchSucceeded) {
                final filters = state.items;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final item = filters[index];
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
                  itemCount: filters.length,
                );
              } else if (state is SearchInitial) {
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
              return const CircularProgressIndicator();
            },
          ),
        ),*/
      ],
    );
  }
}
