import 'package:flutter/material.dart';


class ProfileGridTile extends StatelessWidget {
  final void Function() onPress;
  final String image;

  const ProfileGridTile({super.key, required this.onPress, required this.image,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 60.0,
            child: const Padding(
              padding: EdgeInsets.only(left: 88.0, bottom: 88.0),
              // child: PBInvertedIconButton(icon: Symbols.edit_rounded, onPressed: () {}, size: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}
