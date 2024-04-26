import 'package:flutter/material.dart';


class PokeListTile extends StatelessWidget {
  final String bleTitle;
  final void Function() onPress;
  final Widget leading;

  PokeListTile({required this.bleTitle, required this.onPress, required this.leading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          bleTitle,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20.0,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        onTap: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
        leading: leading,
      ),
    );
  }



}
