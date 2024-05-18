import 'package:flutter/material.dart';

import '../utilities/color_schemes.g.dart';

class PokeStatTile extends StatelessWidget {
  final Widget content;
  final String type;
  final String type2;

  PokeStatTile({required this.content, required this.type, required this.type2});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              colors: [
                getTypeBackgroundColor(type).withOpacity(0.8),
                type2 != '' ? getTypeBackgroundColor(type2).withOpacity(0.8) : getTypeBackgroundColor(type).withOpacity(0.8),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.3, 0.7],
              tileMode: TileMode.clamp,
            ),
          ),
          child: content),
    );
  }
}
