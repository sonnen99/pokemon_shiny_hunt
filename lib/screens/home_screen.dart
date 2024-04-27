import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import '../widgets/poke_hunt_list_tile.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'images/pokeball_dark.png' : 'images/pokeball_light.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PokeHuntListTile(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bulbasaur',
                        style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                      Text(
                        '205',
                        style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                    ],
                  ),
                ],
              ),
              onPress: () {},
              leading: Image.asset('pokemon/001_Bulbasaur_cover.png',),
            ),
          ],
        ),
      ),
    );
  }
}
