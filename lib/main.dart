import 'package:flutter/material.dart';

import 'pages/list_filters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter filters example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FiltersListScreen(),
    );
  }
}
