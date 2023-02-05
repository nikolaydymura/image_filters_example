import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final Widget outputText;
  const TabsWidget({super.key, required this.outputText});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Align(
        alignment: Alignment.center,
        child: outputText,
      ),
    );
  }
}
