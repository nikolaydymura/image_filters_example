// ignore_for_file: require_trailing_commas
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_bloc/search_bloc.dart';

const Map<String, List<String>> favorites = {
  'CIFilterConfiguration': [
    'Color Cube',
    'Color Monochrome + Color Threshold',
    'Color Cubes Mixed With Mask',
    'Color Cube with ColorSpace',
    'Color Monochrome',
    'Square Lookup Table',
  ],
  'GPUFilterConfiguration': [
    'Brightness + Contrast',
    'SquareLookupTable + Brightness + Contrast + Exposure',
    'HALD Lookup Table',
    'Monochrome',
    'Square Lookup Table',
  ],
  'ShaderConfiguration': [
    'Brightness + Contrast',
    'Lookup + Contrast + Brightness + Exposure',
    'HALD Lookup + Contrast + Brightness + Exposure',
    'Brightness + Saturation',
    'HALD Lookup Table',
    'Monochrome',
    'Square Lookup Table',
  ],
};

class ListSupportedFiltersWidget<T extends SearchableBloc>
    extends StatelessWidget {
  final String configuration;
  final Function(String) onItemTap;

  const ListSupportedFiltersWidget({
    super.key,
    required this.onItemTap,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> filters = favorites[configuration] ?? [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<T, SearchState>(
            builder: (context, state) {
              return TextField(
                controller: state.controller,
                onChanged: (value) => context.read<T>().search(value),
                focusNode: state.focusNode,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Theme.of(context).primaryColor,
                  suffix: InkWell(
                    onTap: () => context.read<T>().reset(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(context).cardTheme.color,
                  ),
                  labelText: 'Search',
                  hintText: 'Type filter name',
                ),
              );
            },
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filters[index];
                    return Card(
                      color: Theme.of(context).primaryColor,
                      child: ListTile(
                        trailing: const Icon(Icons.navigate_next),
                        title: Text(item),
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
              BlocBuilder<T, SearchState>(
                builder: (context, state) {
                  if (state is SearchSucceeded) {
                    final items = state.items;
                    return SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate((context, index) {
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
                      }, childCount: items.length),
                      itemExtent: 64,
                    );
                  }
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Founded nothing',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
