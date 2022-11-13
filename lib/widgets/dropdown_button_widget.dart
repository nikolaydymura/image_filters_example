import 'package:flutter/material.dart';

final List<String> luts = [
  'lut/filter_lut_1.png',
  'lut/filter_lut_2.png',
  'lut/filter_lut_3.png',
  'lut/filter_lut_4.png',
  'lut/filter_lut_5.png',
  'lut/filter_lut_6.png',
  'lut/filter_lut_7.png',
  'lut/filter_lut_8.png',
  'lut/filter_lut_9.png',
  'lut/filter_lut_10.png',
  'lut/filter_lut_11.png',
  'lut/filter_lut_12.png',
  'lut/filter_lut_13.png',
];

class DropdownButtonWidget extends StatefulWidget {
  const DropdownButtonWidget({super.key});

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String dropdownValue = luts.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 8,
      style: TextStyle(color: Theme.of(context).primaryColor),
      underline: Container(
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: luts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(value),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    value.substring(4),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
