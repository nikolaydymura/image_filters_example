import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import '../blocs/data_bloc/data_bloc_cubit.dart';

class DataDropdownButtonWidget extends StatelessWidget {
  final DataParameter parameter;

  const DataDropdownButtonWidget({
    super.key,
    required this.parameter,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 24, 120),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    parameter.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  //TODO: context.read<DataBlocCubit>().addItem();
                },
                icon: const Icon(
                  Icons.import_export,
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<DataBlocCubit>().loadFile();
                },
                icon: const Icon(Icons.file_upload),
              ),
              const Text('File...')
            ],
          ),
          BlocBuilder<DataBlocCubit, DataBlocState>(
            builder: (context, state) {
              return DropdownButton<DataItem>(
                value: state.selected,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 8,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                underline: Container(
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (DataItem? value) {
                  if (value != null) {
                    context.read<DataBlocCubit>().change(value);
                  }
                },
                items: state.items
                    .map<DropdownMenuItem<DataItem>>((DataItem value) {
                  return DropdownMenuItem<DataItem>(
                    value: value,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(
                          MediaQuery.of(context).size.width / 2 - (32 + 24),
                          120,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 50,
                              maxHeight: 50,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: _dataPreview(value),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              value.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
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
            },
          )
        ],
      ),
    );
  }

  Widget _dataPreview(DataItem value) {
    if (value is ImageAssetDataItem) {
      return Image.asset(value.asset);
    } else if (value is ImageFileDataItem) {
      return Image.file(value.file);
    } else if (value is ImageBinaryDataItem) {
      return Image.memory(value.bytes);
    }
    return const Icon(Icons.raw_on);
  }
}
