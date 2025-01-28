import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pokemon_shiny_hunt/screens/single_pokemon_screen.dart';

import '../models/caught_pokemon.dart';
import '../models/my_pokemon.dart';
import '../utilities/tags.dart';
import '../widgets/poke_grid_tile.dart';

final _firestore = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

class MissingShiniesScreen extends StatefulWidget {
  static const String id = 'missing_screen';

  const MissingShiniesScreen({super.key});

  @override
  State<MissingShiniesScreen> createState() => _MissingShiniesScreenState();
}

class _MissingShiniesScreenState extends State<MissingShiniesScreen> {
  String id = '';
  List<MyPokemon> pokemonList = [];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: id != ''
            ? StreamBuilder(
                stream: _firestore.collection(fbUsers).doc(id).collection(fbShinies).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CaughtPokemon> shinyList = [];
                    for (var pokemon in snapshot.data!.docs) {
                      shinyList.add(
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
                          game: pokemon[fbGame],
                        ),
                      );
                    }
                    return StreamBuilder(
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
                            for (var pokemon in shinyList) {
                              pokemonList.removeWhere((element) => element.name == pokemon.name);
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: pokemonList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PokeGridTile(
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SinglePokemonScreen(
                                            pokemonList: pokemonList,
                                            index: index,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  leading: Image.asset(
                                    'pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png',
                                  ),
                                  type: pokemonList[index].type,
                                  type2: pokemonList[index].type2,
                                  tag: '${pokemonList[index].id}select',
                                  id: pokemonList[index].id,
                                );
                              },
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
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
                        });
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
              )
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
      ),
    );
  }

  Future<void> getInfo() async {
    id = (await storage.read(key: stUID))!;
    if (mounted) {
      setState(() {
        id;
      });
    }
  }
}
