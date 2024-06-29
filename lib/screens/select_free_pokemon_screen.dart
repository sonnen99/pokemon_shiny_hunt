import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_inverted_icon_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field_free.dart';

import '../models/my_pokemon.dart';
import '../utilities/tags.dart';
import '../widgets/poke_grid_tile.dart';
import '../widgets/poke_text_field.dart';

final _firestore = FirebaseFirestore.instance;

class SelectFreePokemonScreen extends StatefulWidget {
  final String UID;

  const SelectFreePokemonScreen({required this.UID});

  @override
  State<SelectFreePokemonScreen> createState() => _SelectFreePokemonState();
}

class _SelectFreePokemonState extends State<SelectFreePokemonScreen> {
  String search = '';
  int tapped_index = 0;
  List<MyPokemon> pokemonList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pokemonList.isNotEmpty ? '#${pokemonList[tapped_index].id} ${pokemonList[tapped_index].name}' : '',
              style: kHeadline2TextStyle,
            ),
            const SizedBox(
              height: 10.0,
            ),
            PokeTextFieldFree(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                labelText: 'Search',
                textEditingController: _controller,
                obscureText: false,
                keyboardType: TextInputType.name),
            const SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection(fbPokemon).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    pokemonList.clear();
                    for (var pokemon in snapshot.data!.docs) {
                      pokemonList.add(
                        MyPokemon(
                          id: pokemon[fbPID],
                          name: pokemon[fbPName],
                          type: pokemon[fbType],
                          type2: pokemon[fbTwoTypes] ? pokemon[fbType2] : '',
                          gen: pokemon[fbGen],
                        ),
                      );
                    }

                    if (search != '') {
                      pokemonList = pokemonList.where((element) => element.name.toLowerCase().contains(search)).toList();
                    }
                    pokemonList.sort((a, b) => a.id.compareTo(b.id));

                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: pokemonList.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool tapped = index == tapped_index;
                        return PokeGridTile(
                          onPress: () {
                            setState(() {
                              tapped_index = index;
                            });
                          },
                          leading: Image.asset(
                            'pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png',
                          ),
                          type: tapped ? 'selected' : pokemonList[index].type,
                          type2: tapped ? 'selected' : pokemonList[index].type2,
                          tag: pokemonList[index].id,
                          id: pokemonList[index].id,
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(
                      child: Lottie.asset(
                        'animations/pikachu_loading.json',
                        fit: BoxFit.fill,
                        frameRate: FrameRate.max,
                        repeat: true,
                        animate: true,
                        width: 200.0,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
                PokeElevatedButton(
                  onPressed: () {
                    Navigator.pop(context,
                        [pokemonList[tapped_index].name, pokemonList[tapped_index].id, pokemonList[tapped_index].type, pokemonList[tapped_index].type2]);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.save_rounded,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Save',
                        style: kButtonTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
