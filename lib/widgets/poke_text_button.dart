import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class PokeTextButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String text;
  final Color? color;

  const PokeTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            text,
            style: kErrorTextStyle.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
