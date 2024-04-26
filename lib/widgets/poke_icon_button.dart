import 'package:flutter/material.dart';

class PokeIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final double size;

  PokeIconButton({required this.icon, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        shape: const CircleBorder(),
        onPressed: onPressed,
        padding: const EdgeInsets.all(4.0),
        color: Theme.of(context).colorScheme.primary,
        disabledColor: Theme.of(context).colorScheme.surfaceVariant,
        disabledElevation: 0,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: size,
        ),
      ),
    );
  }
}
