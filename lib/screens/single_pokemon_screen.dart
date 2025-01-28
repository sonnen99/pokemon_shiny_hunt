import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/color_schemes.g.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_icon_button.dart';

import '../models/my_pokemon.dart';

final _firestore = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

class SinglePokemonScreen extends StatefulWidget {
  final List<MyPokemon> pokemonList;
  final int index;

  const SinglePokemonScreen({super.key,
    required this.pokemonList,
    required this.index,
  });

  @override
  State<SinglePokemonScreen> createState() => _SinglePokemonScreenState();
}

class _SinglePokemonScreenState extends State<SinglePokemonScreen> with SingleTickerProviderStateMixin {
  String gen = '';
  String cls = '';
  String height = '';
  String weight = '';
  String type1 = '';
  String type2 = '';
  String UID = '';
  String PID = '';
  String name = '';
  int index = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    PID = widget.pokemonList[index].id;
    name = widget.pokemonList[index].name;
    type1 = widget.pokemonList[index].type;
    getPokemonData(PID);
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      appBar: AppBar(
        title: const Text(
          'Pokemon',
          style: kHeadline2TextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  elevation: 4.0,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            Theme.of(context).brightness == Brightness.dark ? 'images/pokeball_dark.png' : 'images/pokeball_light.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: kHeadline1TextStyle.copyWith(
                                  color: getTypeBackgroundColor(type1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              PID.characters.last == 'f'
                                  ? Icon(
                                      Symbols.female_rounded,
                                      color: getTypeBackgroundColor(type1),
                                      size: 36.0,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          loading
                              ? Center(
                                  child: Lottie.asset(
                                    'animations/pikachu_loading.json',
                                    fit: BoxFit.fill,
                                    frameRate: FrameRate.max,
                                    repeat: true,
                                    animate: true,
                                    height: 360.0,
                                  ),
                                )
                              : Image.asset(
                                  'pokemon/${PID}_${name}_cover.png',
                                  height: 240.0,
                                ),
                          loading
                              ? const SizedBox()
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'pokemon/${PID}_${name}_normal.png',
                                      width: 120.0,
                                    ),
                                    Hero(
                                      tag: '${PID}select',
                                      child: Image.asset(
                                        'pokemon/${PID}_${name}_shiny.png',
                                        width: 120.0,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Text(
                    'Pokemon details',
                    style: kHeadline2TextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pokedex:',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '#$PID',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                            child: Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Generation:',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                gen,
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                            child: Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Type: ',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Row(
                                children: [
                                  type1 != ''
                                      ? SizedBox(
                                          height: 20.0,
                                          child: Image.asset(
                                            'types/$type1.gif',
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  type2 != ''
                                      ? SizedBox(
                                          height: 20.0,
                                          child: Image.asset(
                                            'types/$type2.gif',
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                            child: Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Classification:',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '$cls Pokemon',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                            child: Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Height:',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '$height m',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                            child: Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weight:',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '$weight kg',
                                style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PokeIconButton(
                        icon: Symbols.keyboard_arrow_left_rounded,
                        onPressed: index > 0
                            ? () {
                                setState(() {
                                  loading = true;
                                });
                                index--;
                                PID = widget.pokemonList[index].id;
                                getPokemonData(PID);
                              }
                            : null,
                        size: 44.0),
                    FloatingActionButton.large(
                      backgroundColor: Colors.transparent,
                      heroTag: 'ball',
                      onPressed: () {
                        final DateTime now = DateTime.now();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String date = formatter.format(now);
                        final newHunt = <String, dynamic>{
                          fbPID: PID,
                          fbPName: name,
                          fbType: type1,
                          fbType2: type2,
                          fbEncounter: 0,
                          fbStart: date,
                          fbEnd: '',
                          fbNickname: '',
                          fbTime: 0,
                          fbRate: 'Rate',
                          fbGame: 'Game',
                        };
                        _firestore.collection(fbUsers).doc(UID).collection(fbCurrentHunts).doc(PID).set(
                          newHunt,
                          SetOptions(merge: true),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HuntScreen(
                                PID: PID,
                                name: name,
                                type: type1,
                                type2: type2,
                                UID: UID,
                                rate: 'Rate',
                                game: 'Game',
                              );
                            },
                          ),
                        );
                      },
                      shape: const CircleBorder(),
                      child: SvgPicture.asset('images/colored_pokeball.svg'),
                    ),
                    PokeIconButton(
                        icon: Symbols.keyboard_arrow_right_rounded,
                        onPressed: index < widget.pokemonList.length - 1
                            ? () {
                                setState(() {
                                  loading = true;
                                });
                                index++;
                                PID = widget.pokemonList[index].id;
                                getPokemonData(PID);
                              }
                            : null,
                        size: 44.0),
                  ],
                ),
                const SizedBox(height: 4.0,),
                const Text(
                  'Start hunting',
                  textAlign: TextAlign.center,
                  style: kTextButtonTextStyle,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void getPokemonData(String pid) {
    _firestore.collection(fbPokemon).doc(pid).get().then((value) {
      if (value.exists) {
        name = value.data()?[fbPName];
        gen = value.data()?[fbGen];
        cls = value.data()?[fbClassification];
        type1 = value.data()?[fbType];
        weight = value.data()?[fbWeight];
        height = value.data()?[fbHeight];
        if (value.data()?[fbTwoTypes]) {
          type2 = value.data()?[fbType2];
        }
        setState(() {
          PID;
          name;
          gen;
          cls;
          type1;
          type2;
          weight;
          height;
          loading = false;
        });
      }
    });
  }

  void getInfo() async {
    UID = (await storage.read(key: stUID))!;
  }
}
