import 'dart:core';

import 'package:flutter/material.dart';

class FavoriteWidgets extends StatelessWidget {
  final String configuration;
  final Function(String) onItemTap;

  const FavoriteWidgets(
      {Key? key, required this.configuration, required this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> favorites = {
      'CIFilterConfiguration': [
        'Color Monochrome',
        'Color Cube',
        'Lookup Table',
      ],
      'GPUFilterConfiguration': [
        'Monochrome',
        'Square Lookup Table',
        'HALD Lookup Table',
      ],
      'ShaderConfiguration': [
        'Monochrome',
        'Square Lookup Table',
        'HALD Lookup Table',
      ],
    };
    final List<String> filters = favorites[configuration] ?? [];
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Card(
                color: Colors.greenAccent[200],
                child: ListTile(
                  trailing: const Icon(
                    Icons.navigate_next,
                  ),
                  title: Text(
                    filters[index],
                  ),
                  onTap: () {
                    onItemTap(filters[index]);
                  },
                ),
              );
            },
            childCount: filters.length, // 1000 list items
          ),
        ),
      ],
    );
  }
}
