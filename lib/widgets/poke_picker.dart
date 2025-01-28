import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PokePicker extends StatelessWidget {
  final ValueChanged<int> onSelectedItemChanged;
  final FixedExtentScrollController controller;
  final List<String> sList;
  final bool looping;

  const PokePicker({super.key, required this.onSelectedItemChanged, required this.controller, required this.sList, required this.looping});

  @override
  Widget build(BuildContext context) {
    List<Text> list = [];
    for (int i = 0; i < sList.length; i++) {
      list.add(
        Text(
          sList[i],
          style: kPickerTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      );
    }

    return CupertinoPicker(
      itemExtent: 30.0,
      onSelectedItemChanged: onSelectedItemChanged,
      looping: looping,
      scrollController: controller,
      selectionOverlay: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      children: list,
    );
  }
}
