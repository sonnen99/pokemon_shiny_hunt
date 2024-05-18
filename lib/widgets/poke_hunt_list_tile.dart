import 'package:flutter/material.dart';
import 'package:pokeball_widget/pokeball_widget.dart';


class PokeHuntListTile extends StatelessWidget {
  final Widget content;
  final void Function() onPress;
  final Widget leading;
  final String tag;

  PokeHuntListTile({required this.content, required this.onPress, required this.leading, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: content,
        onTap: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
        leading: Hero(
          tag: tag,
            child: leading),
      ),
    );
  }

}
