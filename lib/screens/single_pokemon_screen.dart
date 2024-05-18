import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import 'package:pokemon_shiny_hunt/screens/select_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/color_schemes.g.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';

final _firestore = FirebaseFirestore.instance;
final storage = FlutterSecureStorage();

class SinglePokemonScreen extends StatefulWidget {
  final String PID;
  final String name;
  final String type;

  const SinglePokemonScreen({required this.PID, required this.name, required this.type,});

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

  @override
  void initState() {
    super.initState();
    getPokemonData(widget.PID);
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: FloatingActionButton.large(
          backgroundColor: Theme.of(context).colorScheme.primary,
          heroTag: 'pokeball',
          onPressed: () {
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat('yyyy-MM-dd');
            final String date = formatter.format(now);
            final newHunt = <String, dynamic>{
              fbPID: widget.PID,
              fbPName: widget.name,
              fbType: type1,
              fbType2: type2,
              fbEncounter: 0,
              fbStart: date,
              fbEnd: '',
              fbNickname: '',
              fbTime: 0,
              fbRate: 'Rate',
            };
            _firestore.collection(fbUsers).doc(UID).collection(fbCurrentHunts).doc(widget.PID).set(
                  newHunt,
                  SetOptions(merge: true),
                );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return HuntScreen(
                PID: widget.PID,
                name: widget.name,
                type: widget.type,
                type2: type2,
                UID: UID,
                rate: 'Rate',
              );
            }));
          },
          shape: const CircleBorder(),
          child: Image.asset('images/playstore.png', fit: BoxFit.cover, gaplessPlayback: true),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'images/pokeball_dark.png' : 'images/pokeball_light.png'),
              alignment: Alignment.topCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    widget.name,
                    style: kHeadline1TextStyle.copyWith(
                      color: getTypeBackgroundColor(widget.type),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Image.asset(
                    'pokemon/${widget.PID}_${widget.name}_cover.png',
                    height: 240.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'pokemon/${widget.PID}_${widget.name}_normal.png',
                        width: 120.0,
                      ),
                      Hero(
                        tag: '${widget.PID}select',
                        child: Image.asset(
                          'pokemon/${widget.PID}_${widget.name}_shiny.png',
                          width: 120.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Pokedex: #${widget.PID}',
                    style: kHeadline2TextStyle,
                  ),
                  Text(
                    'Generation: $gen',
                    style: kHeadline2TextStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Type: ',
                        style: kHeadline2TextStyle,
                      ),
                      type1 != ''
                          ? Container(
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
                          ? Container(
                              height: 20.0,
                              child: Image.asset(
                                'types/$type2.gif',
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    'Classification: $cls Pokemon',
                    style: kHeadline2TextStyle,
                  ),
                  Text(
                    'Height: $height m',
                    style: kHeadline2TextStyle,
                  ),
                  Text(
                    'Weight: $weight kg',
                    style: kHeadline2TextStyle,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Start hunting',
                textAlign: TextAlign.center,
                style: kButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPokemonData(String pid) {
    _firestore.collection(fbPokemon).doc(pid).get().then((value) {
      if (value.exists) {
        gen = value.data()?[fbGen];
        cls = value.data()?[fbClassification];
        type1 = value.data()?[fbType];
        weight = value.data()?[fbWeight];
        height = value.data()?[fbHeight];
        if (value.data()?[fbTwoTypes]) {
          type2 = value.data()?[fbType2];
        }
        setState(() {
          gen;
          cls;
          type1;
          type2;
          weight;
          height;
        });
      }
    });
  }

  void getInfo() async {
    UID = (await storage.read(key: stUID))!;
  }
}
