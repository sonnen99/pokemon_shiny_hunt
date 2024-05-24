import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/models/hunt_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import '../utilities/constants.dart';
import '../utilities/tags.dart';
import '../widgets/poke_hunt_list_tile.dart';

final storage = FlutterSecureStorage();
final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String id = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          id != ''
              ? StreamBuilder(
                  stream: _firestore.collection(fbUsers).doc(id).collection(fbCurrentHunts).snapshots(),
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
                            type2: pokemon.toString().contains(fbType2) ? pokemon[fbType2] : '',
                            start: pokemon[fbStart],
                            end: pokemon[fbEnd],
                            nickname: pokemon[fbNickname],
                            time: pokemon[fbTime],
                            rate: pokemon[fbRate],
                          ),
                        );
                      }
                      pokemonList.sort((a, b) => a.id.compareTo(b.id));
                      return Expanded(
                        child: ListView.builder(
                            itemCount: pokemonList.length,
                            itemBuilder: (context, index) {
                              return PokeHuntListTile(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              pokemonList[index].name,
                                              style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
                                            ),
                                            pokemonList[index].id.characters.last == 'f'
                                                ? Icon(
                                                    Symbols.female_rounded,
                                                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                                                    size: 30.0,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        Text(
                                          pokemonList[index].encounter.toString(),
                                          style: kSurfaceTextStyle.copyWith(color: Theme.of(context).colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HuntScreen(
                                          PID: pokemonList[index].id,
                                          name: pokemonList[index].name,
                                          type: pokemonList[index].type,
                                          type2: pokemonList[index].type2,
                                          UID: id,
                                          rate: pokemonList[index].rate,
                                        );
                                      },
                                    ),
                                  );
                                },
                                leading: Image.asset('pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png'),
                                tag: '${pokemonList[index].id}home',
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Lottie.asset(
                          'pikachu_loading.json',
                          fit: BoxFit.fill,
                          frameRate: FrameRate.max,
                          repeat: true,
                          animate: true,
                          width: 200.0,
                          height: 200.0,
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
                    height: 200.0,
                  ),
                ),
        ],
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
