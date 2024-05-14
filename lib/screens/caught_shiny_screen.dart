import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/screens/hunt_screen.dart';
import 'package:pokemon_shiny_hunt/screens/select_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/color_schemes.g.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_delete_alert.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../widgets/poke_inversed_icon_button.dart';

final _firestore = FirebaseFirestore.instance;
final storage = FlutterSecureStorage();

class CaughtShinyScreen extends StatefulWidget {
  final String PID;
  final String name;
  final String type;
  final int encounter;
  final String start;
  final String end;
  final String nickname;
  final int time;
  final String rate;

  const CaughtShinyScreen(
      {required this.PID,
      required this.name,
      required this.type,
      required this.encounter,
      required this.start,
      required this.end,
      required this.nickname,
      required this.time,
      required this.rate});

  @override
  State<CaughtShinyScreen> createState() => _CaughtShinyScreenState();
}

class _CaughtShinyScreenState extends State<CaughtShinyScreen> with SingleTickerProviderStateMixin {
  String gen = '';
  String cls = '';
  String height = '';
  String weight = '';
  String type1 = '';
  String type2 = '';
  String UID = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPokemonData(widget.PID);
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 10.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => PokeDeleteAlert(
                    title: 'Delete shiny?',
                    content: '#${widget.PID} ${widget.name} ',
                    onYes: () {
                      _firestore.collection(fbUsers).doc(UID).collection(fbShinies).doc(widget.PID).delete();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                );
              },
              child: Icon(
                Symbols.delete_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 36.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PokeInvertedIconButton(
        icon: Symbols.home_rounded,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        size: 44.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'images/pokeball_dark.png' : 'images/pokeball_light.png'),
                alignment: Alignment.topCenter),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      widget.nickname == '' ? widget.name : widget.nickname,
                      style: kHeadline1TextStyle.copyWith(
                        color: getTypeBackgroundColor(widget.type),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          'pokemon/${widget.PID}_${widget.name}_cover.png',
                          height: 240.0,
                        ),
                        Lottie.asset(
                          'animations/static_stars.json',
                          fit: BoxFit.fill,
                          animate: true,
                          repeat: true,
                          frameRate: FrameRate.max,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'pokemon/${widget.PID}_${widget.name}_normal.png',
                          width: 120.0,
                        ),
                        Image.asset(
                          'pokemon/${widget.PID}_${widget.name}_shiny.png',
                          width: 120.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Encountered at: ',
                          style: kHeadline2TextStyle,
                        ),
                        Text(
                          widget.encounter.toString(),
                          style: kHeadline1TextStyle.copyWith(
                            color: getTypeBackgroundColor(widget.type),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'at rate: ',
                          style: kHeadline2TextStyle,
                        ),
                        Text(
                          widget.rate,
                          style: kHeadline1TextStyle.copyWith(
                            color: getTypeBackgroundColor(widget.type),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'after ',
                          style: kHeadline2TextStyle,
                        ),
                        Text(
                          StopWatchTimer.getDisplayTime(widget.time),
                          style: kHeadline1TextStyle.copyWith(
                            color: getTypeBackgroundColor(widget.type),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Started: ${widget.start}',
                      style: kHeadline2TextStyle,
                    ),
                    Text(
                      'Caught: ${widget.end}',
                      style: kHeadline2TextStyle,
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
            ],
          ),
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
