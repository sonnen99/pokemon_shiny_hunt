import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';

class PokeSaveButton extends StatelessWidget {
  final void Function()? onPress;

  const PokeSaveButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return PokeElevatedButton(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          const Icon(
            Symbols.keyboard_arrow_right_rounded,
          ),
        ],
      ),
    );
  }
}
