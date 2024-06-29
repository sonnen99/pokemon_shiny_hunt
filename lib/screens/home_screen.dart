import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/models/hunt_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_delete_alert.dart';
import '../utilities/constants.dart';
import '../utilities/tags.dart';
import '../widgets/poke_hunt_list_tile.dart';
import 'add_shiny_screen.dart';

final storage = const FlutterSecureStorage();
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
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat('yyyy-MM-dd');
            final String date = formatter.format(now);
            final newHunt = <String, dynamic>{
              fbPID: '00000',
              fbPName: 'Free',
              fbType: 'normal',
              fbType2: 'normal',
              fbEncounter: 0,
              fbStart: date,
              fbEnd: '',
              fbNickname: '',
              fbTime: 0,
              fbRate: 'Rate',
            };
            _firestore.collection(fbUsers).doc(id).collection(fbCurrentHunts).doc('00000').set(
              newHunt,
              SetOptions(merge: true),
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return HuntScreen(
                PID: '00000',
                name: 'Free',
                type: 'normal',
                type2: 'normal',
                UID: id,
                rate: 'Rate',
              );
            }));
          },
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          label: const Text(
            'Free',
            style: kButtonTextStyle,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            id != ''
                ? Flexible(
                  child: StreamBuilder(
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
                          return ListView.builder(
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
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => PokeDeleteAlert(
                                          title: 'Delete hunt?',
                                          onYes: () {
                                            final delete = <String, dynamic>{
                                              'comment': FieldValue.delete(),
                                            };
                                            _firestore
                                                .collection(fbUsers)
                                                .doc(id)
                                                .collection(fbCurrentHunts)
                                                .doc(pokemonList[index].id)
                                                .update(delete);
                                            Navigator.pop(context);
                                          },
                                          content: pokemonList[index].name),
                                    );
                                  },
                                  leading: Image.asset('pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png'),
                                  tag: '${pokemonList[index].id}home',
                                );
                              });
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
                      }),
                )
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
