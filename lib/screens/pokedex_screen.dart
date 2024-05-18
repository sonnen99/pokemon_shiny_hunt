import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/models/data_handler.dart';
import 'package:pokemon_shiny_hunt/models/my_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/add_shiny_screen.dart';
import 'package:pokemon_shiny_hunt/screens/caught_shiny_screen.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_grid_tile.dart';
import 'package:provider/provider.dart';

import '../models/hunt_pokemon.dart';
import '../utilities/tags.dart';

final _firestore = FirebaseFirestore.instance;
final storage = FlutterSecureStorage();

class PokedexScreen extends StatefulWidget {
  static const String id = 'teams_screen';

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  String id = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddShinyScreen(UID: id),
                ),
              ),
            );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            id != ''
                ? StreamBuilder(
                    stream: _firestore.collection(fbUsers).doc(id).collection(fbShinies).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CaughtPokemon> pokemonList = [];
                        for (var pokemon in snapshot.data!.docs) {
                          pokemonList.add(
                            CaughtPokemon(
                              id: pokemon.id,
                              name: pokemon[fbPName],
                              encounter: pokemon[fbEncounter],
                              type: pokemon[fbType],
                              type2: pokemon[fbTwoTypes] ? pokemon[fbType2] : '',
                              start: pokemon[fbStart],
                              end: pokemon[fbEnd],
                              nickname: pokemon[fbNickname],
                              time: pokemon[fbTime],
                              rate: pokemon[fbRate],
                            ),
                          );
                        }
                        pokemonList.sort((a, b) => a.id.compareTo(b.id));
                        switch (Provider.of<DataHandler>(context).sortValue) {
                          case 0:
                            pokemonList.sort((a, b) => a.id.compareTo(b.id));
                            break;
                          case 1:
                            pokemonList.sort((a, b) => b.encounter.compareTo(a.encounter));
                            break;
                          case 2:
                            pokemonList.sort((a, b) => a.encounter.compareTo(b.encounter));
                            break;
                          case 3:
                            pokemonList.sort((a, b) => a.time.compareTo(b.time));
                            break;
                          case 4:
                            pokemonList.sort((a, b) => b.time.compareTo(a.time));
                            break;
                          case 5:
                            pokemonList.sort((a, b) => a.type.compareTo(b.type));
                            break;
                        }

                        return Expanded(
                          child: GridView.builder(
                            itemCount: pokemonList.length,
                            itemBuilder: (context, index) {
                              return PokeGridTile(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CaughtShinyScreen(
                                          PID: pokemonList[index].id,
                                          name: pokemonList[index].name,
                                          type: pokemonList[index].type,
                                          encounter: pokemonList[index].encounter,
                                          start: pokemonList[index].start,
                                          end: pokemonList[index].end,
                                          nickname: pokemonList[index].nickname,
                                          time: pokemonList[index].time,
                                          rate: pokemonList[index].rate,
                                        );
                                      },
                                    ),
                                  );
                                },
                                leading: Image.asset('pokemon/${pokemonList[index].id}_${pokemonList[index].name}_cover.png'),
                                type: pokemonList[index].type,
                                type2: pokemonList[index].type2,
                                tag: '${pokemonList[index].id}shiny',
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                          ),
                        );
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
                    })
                : Center(
                    child: Lottie.asset(
                      'animations/pikachu_loading.json',
                      fit: BoxFit.fill,
                      frameRate: FrameRate.max,
                      repeat: true,
                      animate: true,
                      width: 200.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getInfo() async {
    id = (await storage.read(key: stUID))!;
    setState(() {
      id;
    });
  }
}
