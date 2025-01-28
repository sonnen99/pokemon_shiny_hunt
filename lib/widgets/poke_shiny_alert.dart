import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field_free.dart';

import '../utilities/constants.dart';

class PokeShinyAlert extends StatelessWidget {
  final void Function() onYes;
  final void Function() onNo;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const PokeShinyAlert({super.key, required this.onYes,  required this.onChanged, required this.controller, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 8.0,
          right: 10.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                Symbols.celebration_rounded,
                size: 30.0,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Text(
                'Congratulations you found a shiny pokemon',
                textAlign: TextAlign.center,
                style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                'Do you want to give a nickname?',
                textAlign: TextAlign.center,
                style: kTextButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
      content: PokeTextFieldFree(
        onChanged: onChanged,
        labelText: 'Nickname',
        textEditingController: controller,
        obscureText: false,
        keyboardType: TextInputType.name,
      ),
      actions: [
        TextButton(
          onPressed: onNo,
          child: Text(
            'No',
            style: kTextButtonTextStyle.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        TextButton(
          onPressed: onYes,
          child: Text(
            'Yes',
            style: kTextButtonTextStyle.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ],
      elevation: 24.0,
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
    );
  }
}
