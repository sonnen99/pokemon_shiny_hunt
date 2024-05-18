import 'package:flutter/material.dart';

import '../utilities/color_schemes.g.dart';

class PokeGridTile extends StatelessWidget {
  final void Function() onPress;
  final Widget leading;
  final String type;
  final String type2;
  final String tag;

  PokeGridTile({required this.onPress, required this.leading, required this.type, required this.type2, required this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
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
          child: Center(
            child: Hero(tag: tag, child: leading),
          ),
        ),
      ),
    );
  }
}
