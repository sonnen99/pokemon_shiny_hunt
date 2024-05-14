import 'package:flutter/material.dart';

import '../utilities/color_schemes.g.dart';

class PokeGridTile extends StatelessWidget {
  final void Function() onPress;
  final Widget leading;
  final String type;

  PokeGridTile({required this.onPress, required this.leading, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: getTypeBackgroundColor(type).withOpacity(0.8),
        child: Center(
          child: leading,
        ),
      ),
    );
  }

}


