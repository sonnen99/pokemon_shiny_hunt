import 'package:flutter/material.dart';

import '../utilities/constants.dart';


class PokeCancelButton extends StatelessWidget {
  const PokeCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Cancel',
        style: kTextButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}
