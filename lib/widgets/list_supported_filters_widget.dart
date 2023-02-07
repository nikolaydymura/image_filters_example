import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_bloc/search_bloc.dart';

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
        const SizedBox(
          height: 1,
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
        ),
      ],
    );
  }
}
