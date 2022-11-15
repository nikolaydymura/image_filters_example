import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final Text outputText;
  const TabsWidget({super.key, required this.outputText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).primaryColorLight,
                width: 1,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: outputText,
            ),
          ),
        ),
      ),
    );
  }
}
