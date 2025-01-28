import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/utilities/color_schemes.g.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_delete_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../widgets/poke_inverted_icon_button.dart';

final _firestore = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

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
  final String game;

  const CaughtShinyScreen({super.key,
    required this.PID,
    required this.name,
    required this.type,
    required this.encounter,
    required this.start,
    required this.end,
    required this.nickname,
    required this.time,
    required this.rate,
    required this.game,
  });

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
  void initState() {
    super.initState();
    getPokemonData(widget.PID);
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 60.0,
            child: PokeInvertedIconButton(
                icon: Symbols.delete_rounded,
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
                size: 36.0),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.nickname == '' ? widget.name : widget.nickname,
                              style: kHeadline1TextStyle.copyWith(
                                color: getTypeBackgroundColor(widget.type),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            widget.PID.characters.last == 'f'
                                ? Icon(
                                    Symbols.female_rounded,
                                    color: getTypeBackgroundColor(widget.type),
                                    size: 36.0,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          fit: StackFit.passthrough,
                          children: [
                            Hero(
                              tag: '${widget.PID}shiny',
                              child: Image.asset(
                                'pokemon/${widget.PID}_${widget.name}_cover.png',
                                height: 240.0,
                              ),
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
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Encounters: ',
                        style: kHeadline2TextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        widget.encounter.toString(),
                        style: kHeadline1TextStyle.copyWith(
                          color: getTypeBackgroundColor(widget.type),
                        ),
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
                        'Total time:',
                        style: kHeadline2TextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        StopWatchTimer.getDisplayTime(widget.time),
                        style: kHeadline1TextStyle.copyWith(
                          color: getTypeBackgroundColor(widget.type),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.0,
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Text(
                    'Hunt details',
                    style: kHeadline2TextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                          border: Border.all(color: Theme.of(context).colorScheme.onSecondaryContainer, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Game:',
                                  style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  widget.game,
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
                                  'Encounter rate:',
                                  style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  widget.rate,
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
                                  'Started:',
                                  style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  widget.start,
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
                                  'Caught:',
                                  style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  widget.end,
                                  style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Pokemon details',
                    style: kHeadline2TextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                  '#${widget.PID}',
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
                                    if (type1 != '')
                                      SizedBox(
                                        height: 20.0,
                                        child: Image.asset(
                                          'types/$type1.gif',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    if (type2 != '')
                                      SizedBox(
                                        height: 20.0,
                                        child: Image.asset(
                                          'types/$type2.gif',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
