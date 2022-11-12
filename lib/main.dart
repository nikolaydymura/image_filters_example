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
        primarySwatch: Colors.deepPurple,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        cardColor: Colors.deepPurple[200],
      ),
      home: const FiltersListScreen(),
    );
  }
}
