import 'package:flutter/material.dart';

import 'package:image_filters/image_filters.dart';

class FiltersListScreen extends StatefulWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  @override
  State<FiltersListScreen> createState() => _FiltersListScreenState();
}

class _FiltersListScreenState extends State<FiltersListScreen> {
  final _items = availableShaders.keys.toList();
  @override
  void initState() {
    super.initState();
    _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('List filters')),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
          );
        },
      ),
    );
  }
}
