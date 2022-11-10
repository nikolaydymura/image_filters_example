import 'package:flutter/material.dart';
import 'package:image_filters/image_filters.dart';

import 'filters_details.dart';

class FiltersListScreen extends StatelessWidget {
  const FiltersListScreen({Key? key}) : super(key: key);

  List<String> get _items => availableShaders.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Available filters')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 8,
          ),
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
