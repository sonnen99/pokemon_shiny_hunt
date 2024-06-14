import 'package:flutter/material.dart';

class PokeInvertedIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final double size;

  PokeInvertedIconButton({required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: const CircleBorder(),
      onPressed: onPressed,
      padding: const EdgeInsets.all(6.0),
      color: Colors.transparent,
      disabledColor: Theme.of(context).colorScheme.surfaceVariant,
      disabledElevation: 0,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: size,
      ),

    );
  }
}