import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/utilities/color_schemes.g.dart';

import '../utilities/constants.dart';

class PokeHuntListTile extends StatelessWidget {
  final CaughtPokemon pokemon;
  final void Function() onPress;
  final DismissDirectionCallback? onDismiss;
  final Widget leading;
  final String tag;
  final String type;

  const PokeHuntListTile({super.key, required this.pokemon,required this.onPress, required this.leading, required this.tag, required this.onDismiss, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.0,
          ),
        ),
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Symbols.delete_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: onDismiss,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              pokemon.name,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: kPickerTextStyle.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                            ),
                          ),
                          pokemon.id.characters.last == 'f'
                              ? Icon(
                            Symbols.female_rounded,
                            color: Theme.of(context).colorScheme.primaryContainer,
                            size: 30.0,
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Text(
                      pokemon.encounter.toString(),
                      style: kSurfaceTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryFixed),
                    ),
                  ],
                ),
              ],
            ),
            onTap: onPress,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            tileColor: getTypeBackgroundColor(type).withAlpha(220),
            iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
            leading: Hero(
              tag: tag,
              child: leading,
            ),
          ),
        ),
      ),
    );
  }
}
