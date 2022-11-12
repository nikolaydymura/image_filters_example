import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';

import 'filters_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  List<String> get _items =>
      SplayTreeSet<String>.from(availableShaders.keys).toList();

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
                      builder: (context) =>
                          FilterDetailsScreen(filterName: item),
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
