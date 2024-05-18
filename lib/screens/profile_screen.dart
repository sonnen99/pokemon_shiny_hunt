import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/caught_pokemon.dart';
import 'package:pokemon_shiny_hunt/models/hunt_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/edit_profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_grid_tile.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_stats_tile.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../utilities/constants.dart';

final _firestore = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = const FlutterSecureStorage();
  String email = '';
  String firstName = '';
  String lastName = '';
  String nickName = '';
  String id = '';
  int shinies = 0;
  int encounters = 0;
  int average = 0;
  int most = 0;
  int least = 0;
  int time = 0;
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: id.isEmpty
              ? null
              : () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: EditProfileScreen(
                          uid: id,
                          firstName: firstName,
                          lastName: lastName,
                          nickName: nickName,
                        ),
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      firstName = result[0];
                      lastName = result[1];
                      nickName = result[2];
                      storage.write(key: stFirstName, value: firstName);
                      storage.write(key: stLastName, value: lastName);
                      storage.write(key: stNickName, value: nickName);
                    });
                  }
                },
          shape: const CircleBorder(),
          child: const Icon(
            Symbols.edit_note_rounded,
            size: 30.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/playstore.png'),
                        radius: 60.0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 88.0, bottom: 88.0),
                          // child: PBInvertedIconButton(icon: Symbols.edit_rounded, onPressed: () {}, size: 24.0),
                        ),
                      ),
                    ),
                    Text(
                      nickName,
                      style: kHeadline1TextStyle.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trainer:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      firstName != null ? '$firstName $lastName' : '',
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Email: ',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      email ?? '',
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Shiny stats:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    // most, least, total caught, total encounters, average encounters
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: StaggeredGrid.count(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
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
                                          style: kEncounterNumberStyle.copyWith(fontSize: 80.0),
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
                                  encounters != null
                                      ? Text(
                                          encounters.toString(),
                                          style: kHeadline1TextStyle.copyWith(fontSize: 44.0),
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
                                            StopWatchTimer.getDisplayTime(time),
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
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0, left: 10.0),
                child: TextButton(
                  onPressed: () {
                    storage.deleteAll();
                    Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.logout_rounded,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Logout',
                        style: kErrorTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0, left: 10.0),
                child: TextButton(
                  onPressed: () {
                    //TODO delete profile
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.delete_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Delete',
                        style: kErrorTextStyle.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getInfo() async {
    email = (await storage.read(key: stEmail))!;
    id = (await storage.read(key: stUID))!;
    getStats();
    setState(() {
      email;
      id;
    });
    firstName = (await storage.read(key: stFirstName))!;
    lastName = (await storage.read(key: stLastName))!;
    nickName = (await storage.read(key: stNickName))!;
    setState(() {
      firstName;
      lastName;
      nickName;
    });
  }

  void getStats() {
    List<CaughtPokemon> pokemonList = [];
    int totalTime = 0;
    _firestore.collection(fbUsers).doc(id).collection(fbShinies).get().then((value) {
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
      }
    });
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
