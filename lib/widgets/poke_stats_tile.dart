import 'package:flutter/material.dart';

import '../utilities/color_schemes.g.dart';

class PokeStatTile extends StatelessWidget {

  final Widget content;
  final String type;

  PokeStatTile({required this.content, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: getTypeBackgroundColor(type).withOpacity(0.8),
      child: content,
    );
  }

}


