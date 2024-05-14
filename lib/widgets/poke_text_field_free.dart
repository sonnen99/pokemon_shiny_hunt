import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PokeTextFieldFree extends StatelessWidget {
  final void Function(String) onChanged;
  final String labelText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType keyboardType;

  PokeTextFieldFree({required this.onChanged, required this.labelText, required this.textEditingController, required this.obscureText, required this.keyboardType});

  @override
  Widget build(BuildContext context) {

      return TextField(
        autofocus: true,
        style: kScreenTitleStyle,
        cursorColor: Theme.of(context).colorScheme.onSecondaryContainer,
        controller: textEditingController,
        keyboardAppearance: Theme.of(context).brightness,
        cursorRadius: const Radius.circular(
          1.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          labelText: labelText,
          labelStyle: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onSurfaceVariant),
          floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondaryContainer, width: 3.0),
          ),
          focusColor: Theme.of(context).colorScheme.error,
        ),
        textAlign: TextAlign.start,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
      );
  }
}
