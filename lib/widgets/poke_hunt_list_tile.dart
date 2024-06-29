import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokeball_widget/pokeball_widget.dart';

class PokeHuntListTile extends StatelessWidget {
  final Widget content;
  final void Function() onPress;
  final void Function() onLongPress;
  final Widget leading;
  final String tag;

  PokeHuntListTile({required this.content, required this.onPress, required this.onLongPress, required this.leading, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          title: content,
          onTap: onPress,
          onLongPress: onLongPress,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          tileColor: Theme.of(context).colorScheme.tertiaryContainer,
          iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
          leading: Hero(tag: tag, child: leading),
        ),
      ),
    );
  }
}
