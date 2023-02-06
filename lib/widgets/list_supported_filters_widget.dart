import 'package:flutter/material.dart';

import 'favourite_widgets.dart';

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
    return Column(
      children: [
        FavoriteWidgets(configuration: configuration, onItemTap: onItemTap),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
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
          ),
        ),
      ],
    );
  }
}
