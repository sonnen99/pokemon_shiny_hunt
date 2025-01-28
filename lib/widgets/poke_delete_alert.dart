import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utilities/constants.dart';

class PokeDeleteAlert extends StatelessWidget {
  final String title;
  final String content;
  final void Function() onYes;

  const PokeDeleteAlert({super.key, required this.title, required this.onYes, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 8.0,
          right: 10.0,
        ),
        child: Row(
          children: [
            Icon(
              Symbols.delete_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: 32.0,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              title,
              style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
          Text(
            content,
            style: kErrorTextStyle.copyWith(color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'No',
            style: kTextButtonTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
        TextButton(
          onPressed: onYes,
          child: Text(
            'Yes',
            style: kTextButtonTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
      elevation: 24.0,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    );
  }
}
