import 'package:flutter/material.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';

class PokeElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;

  const PokeElevatedButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0,),
        textStyle: kElevatedButtonTextStyle,
        iconColor: Theme.of(context).colorScheme.onTertiary,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
