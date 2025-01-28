import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_delete_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../utilities/constants.dart';
import '../utilities/tags.dart';
import '../widgets/poke_hunt_list_tile.dart';
import '../widgets/poke_stats_tile.dart';

const storage = FlutterSecureStorage();
final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String id = '';
  int? shinies;
  int encounters = 0;
  int? average = 0;
  int most = 0;
  int least = 0;
  int? time;
  String nameMost = '';
  String nameLeast = '';
  String nameFast = '';
  String nameSlow = '';
  String idMost = '';
  String idLeast = '';
  String idFast = '';
  String idSlow = '';
  String typeMost = '';
  String typeLeast = '';
  String typeFast = '';
  String typeSlow = '';
  String type2Most = '';
  String type2Least = '';
  String type2Fast = '';
  String type2Slow = '';

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
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
              fbGame: 'Game',
            };
            _firestore.collection(fbUsers).doc(id).collection(fbCurrentHunts).doc('00000').set(
                  newHunt,
                  SetOptions(merge: true),
                );
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HuntScreen(
                PID: '00000',
                name: 'Free',
                type: 'normal',
                type2: 'normal',
                UID: id,
                rate: 'Rate',
                game: 'Game',
              );
            }));
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          label: Text(
            'Free',
            style: kTextButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            id != ''
                ? Expanded(
                    flex: 8,
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
                                  game: pokemon[fbGame],
                                ),
                              );
                            }
                            pokemonList.sort((a, b) => a.id.compareTo(b.id));
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      shrinkWrap: true,
                                      itemCount: pokemonList.length,
                                      itemBuilder: (context, index) {
                                        return PokeHuntListTile(
                                          pokemon: pokemonList[index],
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
                                                    game: pokemonList[index].game,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          onDismiss: (direction) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (_) => PokeDeleteAlert(
                                                  title: 'Delete hunt?',
                                                  onYes: () {
                                                    _firestore.collection(fbUsers).doc(id).collection(fbCurrentHunts).doc(pokemonList[index].id).delete();
                                                    Navigator.pop(context);
                                                  },
                                                  content: pokemonList[index].name),
                                            );
                                          },
                                          leading: Image.asset('pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png'),
                                          tag: '${pokemonList[index].id}home',
                                          type: pokemonList[index].type,
                                        );
                                      }),
                                ),
                              ),
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
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 4.0,
                      ),
                      child: Text(
                        'Shiny stats:',
                        textAlign: TextAlign.start,
                        style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: StaggeredGrid.count(
                        crossAxisCount: 6,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 2,
                        axisDirection: AxisDirection.right,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 3,
                            mainAxisCellCount: 4,
                            child: PokeStatTile(
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  shinies != null
                                      ? Text(
                                          shinies.toString(),
                                          style: kEncounterLargeNumberStyle.copyWith(fontSize: 80.0),
                                        )
                                      : Lottie.asset(
                                          'animations/stars_loading.json',
                                          height: 110.0,
                                          width: 110.0,
                                          animate: true,
                                          repeat: true,
                                          fit: BoxFit.fill,
                                        ),
                                  const Text(
                                    'Total shinies',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: 'fire',
                              type2: 'fire',
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: PokeStatTile(
                              content: Column(
                                children: [
                                  idFast.isNotEmpty
                                      ? Image.asset(
                                          'pokemon/${idFast}_${nameFast}_cover.png',
                                          height: 70.0,
                                        )
                                      : Lottie.asset(
                                          'animations/stars_loading.json',
                                          height: 60.0,
                                          width: 60.0,
                                          animate: true,
                                          repeat: true,
                                          fit: BoxFit.fill,
                                        ),
                                  const Text(
                                    'Fastest',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: typeFast,
                              type2: type2Fast,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: PokeStatTile(
                              content: Column(
                                children: [
                                  idSlow.isNotEmpty
                                      ? Image.asset(
                                          'pokemon/${idSlow}_${nameSlow}_cover.png',
                                          height: 70.0,
                                        )
                                      : Lottie.asset(
                                          'animations/stars_loading.json',
                                          height: 60.0,
                                          width: 60.0,
                                          animate: true,
                                          repeat: true,
                                          fit: BoxFit.fill,
                                        ),
                                  const Text(
                                    'Longest',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: typeSlow,
                              type2: type2Slow,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 4,
                            child: PokeStatTile(
                              content: Column(
                                children: [
                                  Text(
                                    encounters.toString(),
                                    style: kHeadline1TextStyle.copyWith(fontSize: 44.0),
                                  ),
                                  const Text(
                                    'Total encounters',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: 'electric',
                              type2: 'electric',
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 8,
                            child: PokeStatTile(
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Average time:  ',
                                      textAlign: TextAlign.center,
                                      style: kStatsTileTextStyle,
                                    ),
                                    time != null
                                        ? Text(
                                            StopWatchTimer.getDisplayTime(time!),
                                            textAlign: TextAlign.center,
                                            style: kHeadline1TextStyle.copyWith(fontSize: 28.0),
                                          )
                                        : Lottie.asset(
                                            'animations/stars_loading.json',
                                            height: 40.0,
                                            width: 40.0,
                                            animate: true,
                                            repeat: true,
                                            fit: BoxFit.fill,
                                          ),
                                  ],
                                ),
                              ),
                              type: 'grass',
                              type2: 'grass',
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: PokeStatTile(
                              content: Column(
                                children: [
                                  idMost.isNotEmpty
                                      ? Image.asset(
                                          'pokemon/${idMost}_${nameMost}_cover.png',
                                          height: 70.0,
                                        )
                                      : Lottie.asset(
                                          'animations/stars_loading.json',
                                          height: 60.0,
                                          width: 60.0,
                                          animate: true,
                                          repeat: true,
                                          fit: BoxFit.fill,
                                        ),
                                  const Text(
                                    'Most',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: typeMost,
                              type2: type2Most,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 4,
                            child: PokeStatTile(
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Average:  ',
                                      textAlign: TextAlign.center,
                                      style: kStatsTileTextStyle,
                                    ),
                                    average != null
                                        ? Text(
                                            average.toString(),
                                            textAlign: TextAlign.center,
                                            style: kHeadline1TextStyle.copyWith(fontSize: 28.0),
                                          )
                                        : Lottie.asset(
                                            'animations/stars_loading.json',
                                            height: 40.0,
                                            width: 40.0,
                                            animate: true,
                                            repeat: true,
                                            fit: BoxFit.fill,
                                          ),
                                  ],
                                ),
                              ),
                              type: 'fairy',
                              type2: 'fairy',
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: PokeStatTile(
                              content: Column(
                                children: [
                                  idLeast.isNotEmpty
                                      ? Image.asset(
                                          'pokemon/${idLeast}_${nameLeast}_cover.png',
                                          height: 70.0,
                                        )
                                      : Lottie.asset(
                                          'animations/stars_loading.json',
                                          height: 60.0,
                                          width: 60.0,
                                          animate: true,
                                          repeat: true,
                                          fit: BoxFit.fill,
                                        ),
                                  const Text(
                                    'Least',
                                    style: kStatsTileTextStyle,
                                  ),
                                ],
                              ),
                              type: typeLeast,
                              type2: type2Least,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getInfo() async {
    id = (await storage.read(key: stUID))!;
    getStats();
    setState(() {
      id;
    });
  }

  void getStats() async {
    List<CaughtPokemon> pokemonList = [];
    int totalTime = 0;
    await _firestore.collection(fbUsers).doc(id).collection(fbShinies).get().then((value) {
      if (value.docs.isNotEmpty) {
        shinies = value.docs.length;
        for (var pokemon in value.docs) {
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
          int time1 = pokemon[fbTime];
          totalTime += time1;
        }
        for (var pokemon in pokemonList) {
          encounters += pokemon.encounter;
        }
        time = (totalTime / pokemonList.length).round();
        average = (encounters / pokemonList.length).round();
        pokemonList.sort((a, b) => a.encounter.compareTo(b.encounter));
        idMost = pokemonList.last.id;
        nameMost = pokemonList.last.name;
        typeMost = pokemonList.last.type;
        type2Most = pokemonList.last.type2;
        idLeast = pokemonList.first.id;
        nameLeast = pokemonList.first.name;
        typeLeast = pokemonList.first.type;
        type2Least = pokemonList.first.type2;
        pokemonList.sort((a, b) => a.time.compareTo(b.time));
        idFast = pokemonList.first.id;
        nameFast = pokemonList.first.name;
        typeFast = pokemonList.first.type;
        type2Fast = pokemonList.first.type2;
        idSlow = pokemonList.last.id;
        nameSlow = pokemonList.last.name;
        typeSlow = pokemonList.last.type;
        type2Slow = pokemonList.last.type2;
        if (mounted) {
          setState(() {
            shinies;
            encounters;
            average;
            idLeast;
            idMost;
            idFast;
            idSlow;
            nameSlow;
            nameFast;
            nameMost;
            nameLeast;
            type2Slow;
            type2Fast;
            type2Least;
            type2Most;
            typeSlow;
            typeFast;
            typeMost;
            typeLeast;
            time;
          });
        }
      }
    });
  }
}
