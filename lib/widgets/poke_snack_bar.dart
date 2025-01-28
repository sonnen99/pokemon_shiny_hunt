import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PokeSnackBar {
  BuildContext context;

  PokeSnackBar.of(this.context);

  void showSnackBar(String message, bool pos) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: kTextButtonTextStyle.copyWith(
            color: pos ? Theme.of(context).colorScheme.onTertiary : Theme.of(context).colorScheme.onError,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: pos ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.error,
        elevation: 5.0,
        showCloseIcon: true,
        closeIconColor: pos ? Theme.of(context).colorScheme.onTertiary : Theme.of(context).colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      ),
    );
  }
}
