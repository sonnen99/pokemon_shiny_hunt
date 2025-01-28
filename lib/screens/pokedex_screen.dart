import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/models/data_handler.dart';
import 'package:pokemon_shiny_hunt/screens/add_shiny_screen.dart';
import 'package:pokemon_shiny_hunt/screens/caught_shiny_screen.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_grid_tile.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';
import '../utilities/tags.dart';

final _firestore = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

class PokedexScreen extends StatefulWidget {
  static const String id = 'teams_screen';

  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  String id = '';
  int shinyCount = 0;
  int pokemonCount = 0;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton.small(
          onPressed: () {
            PokeModalBottomSheet.of(context).showBottomSheet(
              AddShinyScreen(UID: id),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(30.0),
                child: ListTile(
                  title: Text(
                    '$shinyCount / $pokemonCount',
                    style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onTertiaryFixed),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  tileColor: Theme.of(context).colorScheme.tertiaryFixedDim,
                  iconColor: Theme.of(context).colorScheme.onTertiaryFixed,
                ),
              ),
            ),
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
                              game: pokemon[fbGame],
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
                            shrinkWrap: true,
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
                                          game: pokemonList[index].game,
                                        );
                                      },
                                    ),
                                  );
                                },
                                leading: Image.asset('pokemon/${pokemonList[index].id}_${pokemonList[index].name}_cover.png'),
                                type: pokemonList[index].type,
                                type2: pokemonList[index].type2,
                                tag: '${pokemonList[index].id}shiny',
                                id: pokemonList[index].id,
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
    await _firestore.collection(fbUsers).doc(id).collection(fbShinies).get().then((value) {
      if (value.docs.isNotEmpty) {
        shinyCount = value.docs.length;
      }
    });
    await _firestore.collection(fbPokemon).get().then((value) {
      if (value.docs.isNotEmpty) {
        pokemonCount = value.docs.length;
      }
    });
    if (mounted) {
      setState(() {
        id;
        shinyCount;
        pokemonCount;
      });
    }
  }
}
