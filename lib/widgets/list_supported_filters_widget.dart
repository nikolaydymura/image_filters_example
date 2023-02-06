import 'package:flutter/material.dart';

class ListSupportedFiltersWidget extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTap;

  const ListSupportedFiltersWidget({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
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
}
