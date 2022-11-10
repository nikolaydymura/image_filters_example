import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';

import 'filters_details.dart';

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
        itemBuilder: (context, index) {
          final item = _items[index];

          return Container(
            color: Colors.greenAccent.withAlpha(120),
            child: ListTile(
              title: Text(item),
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterDetailsScreen(),
                  ),
                );
              },
            ),
          );
        },
        itemCount: _items.length,
      ),
    );
  }
}
