import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

class VectorParameterWidget extends StatelessWidget {
  final VectorParameter parameter;
  final VoidCallback onChanged;

  const VectorParameterWidget({
    Key? key,
    required this.parameter,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            parameter.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            _showAlertDialog(context);
          },
          child: const Text(
            'Choice vector parameter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward),
      ],
    );
  }

  _showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      title: Text(parameter.displayName),
      content: StatefulBuilder(
        builder: (context, setState) {
          return ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 500, height: 300),
            child: ListView.builder(
              itemCount: parameter.value.length,
              prototypeItem: ListTile(
                title: Text('${parameter.value.first}'),
              ),
              itemBuilder: (context, index) {
                return TextField(
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          parameter.value[index] -= 0.5;
                        });
                        onChanged.call();
                      },
                      child: const Icon(
                        Icons.arrow_downward,
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          parameter.value[index] += 0.5;
                        });
                        onChanged.call();
                      },
                      child: const Icon(
                        Icons.arrow_upward,
                      ),
                    ),
                  ),
                  onSubmitted: (inputValue) {
                    final value = double.tryParse(inputValue);
                    if (value != null) {
                      parameter.value[index] = value;
                      onChanged.call();
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: parameter.value[index].toStringAsFixed(3),
                  ),
                );
              },
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
