import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utilities/color_schemes.g.dart';

class PokeGridTile extends StatelessWidget {
  final void Function() onPress;
  final Widget leading;
  final String type;
  final String type2;
  final String tag;
  final String id;

  const PokeGridTile({super.key, required this.onPress, required this.leading, required this.type, required this.type2, required this.tag, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [
                getTypeBackgroundColor(type).withOpacity(0.8),
                type2 != '' ? getTypeBackgroundColor(type2).withOpacity(0.8) : getTypeBackgroundColor(type).withOpacity(0.8),
              ],
              begin: const FractionalOffset(
                0.0,
                0.8,
              ),
              end: const FractionalOffset(
                1.0,
                0.2,
              ),
              stops: const [0.3, 0.7],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Hero(tag: tag, child: leading),
                ),
              ),
              if(id.characters.last == 'f') Icon(Symbols.female_rounded, color: Theme.of(context).colorScheme.onPrimary,),
            ],
          ),
        ),
      ),
    );
  }
}
