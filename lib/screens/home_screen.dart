import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utilities/constants.dart';
import '../widgets/poke_hunt_list_tile.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: () {
            // showModalBottomSheet(
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (context) => SingleChildScrollView(
            //     child: Container(
            //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            //       //TODO add new training
            //     ),
            //   ),
            // );
          },
          shape: const CircleBorder(),
          child: const Icon(
            Symbols.add_rounded,
            size: 32.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
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
                        style: kSubHeadlineTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                    ],
                  ),
                ],
              ),
              onPress: () {},
              leading: Image.asset('pokemon/001_Bulbasaur_cover.png'),
            ),
          ],
        ),
      ),
    );
  }
}
