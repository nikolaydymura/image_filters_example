import 'package:flutter/material.dart';

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
    return CustomScrollView(
      slivers: [
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
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
}
