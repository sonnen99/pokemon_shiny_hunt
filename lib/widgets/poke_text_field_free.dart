import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PokeTextFieldFree extends StatelessWidget {
  final void Function(String) onChanged;
  final String labelText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType keyboardType;

  const PokeTextFieldFree({super.key, required this.onChanged, required this.labelText, required this.textEditingController, required this.obscureText, required this.keyboardType});

  @override
  Widget build(BuildContext context) {

      return TextField(
        autofocus: false,
        style: kTextFieldTextStyle,
        cursorColor: Theme.of(context).colorScheme.onSecondaryContainer,
        controller: textEditingController,
        keyboardAppearance: Theme.of(context).brightness,
        cursorRadius: const Radius.circular(
          1.0,
        ),
        cursorWidth: 1.0,
        cursorHeight: 24.0,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 16.0,),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
          labelText: labelText,
          isDense: true,
          labelStyle: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onSurfaceVariant),
          floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(36.0),
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
