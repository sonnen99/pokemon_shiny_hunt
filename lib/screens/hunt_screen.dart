import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokemon_shiny_hunt/screens/select_free_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_inverted_icon_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_modal_bottom_sheet.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_picker.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_shiny_alert.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_snack_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../utilities/color_schemes.g.dart';
import '../utilities/constants.dart';
import '../widgets/poke_icon_button.dart';

final _firestore = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

class HuntScreen extends StatefulWidget {
  static const String id = 'hunt_screen';
  final String PID;
  final String name;
  final String type;
  final String type2;
  final String UID;
  final String rate;
  final String game;

  const HuntScreen(
      {super.key, required this.PID, required this.name, required this.type, required this.UID, required this.rate, required this.type2, required this.game});

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> with TickerProviderStateMixin {
  int encounter = 0;
  String startDate = '';
  String nickname = '';
  late String rate = widget.rate;
  late String game = widget.game;
  int? time;
  bool caught = false;
  final TextEditingController _controller = TextEditingController();
  late final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
  );
  late final AnimationController _buttonAnimationController;
  late final AnimationController _starAnimationController;
  late final FixedExtentScrollController _rateController;
  late final FixedExtentScrollController _gameController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
    );
    _starAnimationController = AnimationController(
      vsync: this,
    );
    _rateController = FixedExtentScrollController(initialItem: rateList.indexWhere((element) => element.contains(widget.rate)));
    _gameController = FixedExtentScrollController(initialItem: gameList.indexWhere((element) => element.contains(widget.game)));
    getStartDate();
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _starAnimationController.dispose();
    _rateController.dispose();
    _gameController.dispose();
    _controller.dispose();
    _stopWatchTimer.onStopTimer();
    time = _stopWatchTimer.rawTime.value;
    _stopWatchTimer.dispose();
    if (!caught) {
      _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
        {
          fbTime: time,
          fbRate: rate,
        },
        SetOptions(merge: true),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      appBar: AppBar(
        title: const Text(
          'Current hunt',
          style: kHeadline2TextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                elevation: 4.0,
                color: Color(Theme.of(context).brightness == Brightness.dark ? 0xFF111318 : 0xFFF9F9FF),
                borderRadius: BorderRadius.circular(30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'images/pokemon_battle_platform.png',
                        ),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.name,
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
                          children: [
                            Hero(
                              tag: '${widget.PID}home',
                              child: Image.asset(
                                'pokemon/${widget.PID}_${widget.name}_shiny.png',
                                height: 240.0,
                                fit: BoxFit.scaleDown,
                                scale: 1.2,
                              ),
                            ),
                            Lottie.asset(
                              'animations/shiny_encounter_stars.json',
                              fit: BoxFit.fill,
                              frameRate: FrameRate.max,
                              repeat: false,
                              animate: true,
                              width: 240.0,
                              height: 240.0,
                              controller: _starAnimationController,
                              onLoaded: (composition) {
                                _starAnimationController.duration = composition.duration;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Material(
                elevation: 4.0,
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Encounter',
                        style: kHeadline2TextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: PokeIconButton(
                              icon: Symbols.remove_rounded,
                              onPressed: () {
                                setState(
                                  () {
                                    if (encounter > 0) {
                                      encounter--;
                                      _firestore
                                          .collection(fbUsers)
                                          .doc(widget.UID)
                                          .collection(fbCurrentHunts)
                                          .doc(widget.PID)
                                          .set({fbEncounter: encounter}, SetOptions(merge: true));
                                    }
                                  },
                                );
                              },
                              size: 60.0,
                            ),
                          ),
                          !caught
                              ? StreamBuilder(
                                  stream: _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.data()![fbEncounter] == null) {
                                        encounter = 0;
                                      } else {
                                        encounter = snapshot.data!.data()![fbEncounter];
                                      }
                                      return Text(
                                        encounter.toString(),
                                        style: encounter <= 9999 ? kEncounterLargeNumberStyle : kEncounterSmallNumberStyle,
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return Center(
                                        child: Lottie.asset(
                                          'animations/stars_loading.json',
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
                              : const SizedBox(),
                          Flexible(
                            child: PokeIconButton(
                              icon: Symbols.add_rounded,
                              onPressed: () {
                                setState(
                                  () {
                                    encounter++;
                                    _firestore
                                        .collection(fbUsers)
                                        .doc(widget.UID)
                                        .collection(fbCurrentHunts)
                                        .doc(widget.PID)
                                        .set({fbEncounter: encounter}, SetOptions(merge: true));
                                  },
                                );
                              },
                              size: 60.0,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Material(
                            elevation: 8.0,
                            borderRadius: BorderRadius.circular(40.0),
                            color: Theme.of(context).colorScheme.primary,
                            child: GestureDetector(
                              onTap: () {
                                _stopWatchTimer.onStopTimer();
                                time = _stopWatchTimer.rawTime.value;
                                _buttonAnimationController.forward();
                                if (encounter != 0 && rate != 'Rate' && game != 'Game') {
                                  Future.delayed(const Duration(milliseconds: 800), () async {
                                    _buttonAnimationController.reset();
                                    final result = await showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => PokeShinyAlert(
                                        onChanged: (value) {
                                          setState(() {
                                            nickname = value;
                                          });
                                        },
                                        controller: _controller,
                                        onYes: () async {
                                          final DateTime now = DateTime.now();
                                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                          final String date = formatter.format(now);
                                          final Map<String, dynamic> newShiny;
                                          if (widget.name == 'Free') {
                                            final result = await PokeModalBottomSheet.of(context).showBottomSheet(SelectFreePokemonScreen(UID: widget.UID));
                                            if (result != null) {
                                              newShiny = <String, dynamic>{
                                                fbPName: result[0],
                                                fbEncounter: encounter,
                                                fbPID: result[1],
                                                fbTwoTypes: result[3] == '' ? false : true,
                                                fbType: result[2],
                                                fbType2: result[3],
                                                fbStart: startDate,
                                                fbEnd: date,
                                                fbNickname: '',
                                                fbTime: time,
                                                fbRate: rate,
                                                fbGame: game,
                                              };
                                              _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(result[1]).set(newShiny);
                                            } else {
                                              return;
                                            }
                                          } else {
                                            newShiny = <String, dynamic>{
                                              fbPName: widget.name,
                                              fbEncounter: encounter,
                                              fbPID: widget.PID,
                                              fbTwoTypes: widget.type2 == '' ? false : true,
                                              fbType: widget.type,
                                              fbType2: widget.type2,
                                              fbStart: startDate,
                                              fbEnd: date,
                                              fbNickname: nickname.trim(),
                                              fbTime: time,
                                              fbRate: rate,
                                              fbGame: game,
                                            };
                                            _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(widget.PID).set(newShiny);
                                          }
                                          setState(() {
                                            caught = true;
                                          });
                                          _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).delete();
                                          Navigator.pop(context, true);
                                        },
                                        onNo: () async {
                                          final Map<String, dynamic> newShiny;
                                          final DateTime now = DateTime.now();
                                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                          final String date = formatter.format(now);
                                          if (widget.name == 'Free') {
                                            final result = await PokeModalBottomSheet.of(context).showBottomSheet(SelectFreePokemonScreen(UID: widget.UID));
                                            if (result != null) {
                                              newShiny = <String, dynamic>{
                                                fbPName: result[0],
                                                fbEncounter: encounter,
                                                fbPID: result[1],
                                                fbTwoTypes: result[3] == '' ? false : true,
                                                fbType: result[2],
                                                fbType2: result[3],
                                                fbStart: startDate,
                                                fbEnd: date,
                                                fbNickname: '',
                                                fbTime: time,
                                                fbRate: rate,
                                                fbGame: game,
                                              };
                                              _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(result[1]).set(newShiny);
                                            } else {
                                              return;
                                            }
                                          } else {
                                            newShiny = <String, dynamic>{
                                              fbPName: widget.name,
                                              fbEncounter: encounter,
                                              fbPID: widget.PID,
                                              fbTwoTypes: widget.type2 == '' ? false : true,
                                              fbType: widget.type,
                                              fbType2: widget.type2,
                                              fbStart: startDate,
                                              fbEnd: date,
                                              fbNickname: '',
                                              fbTime: time,
                                              fbRate: rate,
                                              fbGame: game,
                                            };
                                            _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(widget.PID).set(newShiny);
                                          }
                                          _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).delete();
                                          setState(() {
                                            caught = true;
                                          });
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                    if (result != null) {
                                      if (result) {
                                        _starAnimationController.forward();
                                        Future.delayed(
                                          const Duration(milliseconds: 1000),
                                          () {
                                            Navigator.pushNamedAndRemoveUntil(context, StartScreen.id, (route) => false);
                                          },
                                        );
                                      }
                                    }
                                  });
                                } else {
                                  _buttonAnimationController.reset();
                                  if (encounter == 0) PokeSnackBar.of(context).showSnackBar('Encounter can not be 0', false);
                                  if (rate == 'Rate') PokeSnackBar.of(context).showSnackBar('Please select a rate', false);
                                  if (game == 'Game') PokeSnackBar.of(context).showSnackBar('Please select a game', false);
                                }
                              },
                              child: Lottie.asset(
                                'animations/star_button.json',
                                fit: BoxFit.fill,
                                frameRate: FrameRate.max,
                                repeat: false,
                                animate: true,
                                width: 80.0,
                                height: 80.0,
                                controller: _buttonAnimationController,
                                onLoaded: (composition) {
                                  _buttonAnimationController.duration = composition.duration;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: _stopWatchTimer.rawTime,
                initialData: 0,
                builder: (context, snapshot) {
                  time = snapshot.data;
                  final displayTime = StopWatchTimer.getDisplayTime(time!);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Material(
                      color: Theme.of(context).colorScheme.tertiaryFixedDim,
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          displayTime,
                          style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.onTertiary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PokeInvertedIconButton(
                    icon: Symbols.pause_rounded,
                    onPressed: () {
                      setState(
                        () {
                          _stopWatchTimer.onStopTimer();
                        },
                      );
                    },
                    size: 60.0,
                  ),
                  PokeInvertedIconButton(
                    icon: Symbols.play_arrow_rounded,
                    onPressed: () {
                      setState(
                        () {
                          _stopWatchTimer.onStartTimer();
                        },
                      );
                    },
                    size: 60.0,
                  ),
                  PokeInvertedIconButton(
                    icon: Symbols.device_reset_rounded,
                    onPressed: () {
                      setState(
                        () {
                          _stopWatchTimer.onResetTimer();
                        },
                      );
                    },
                    size: 60.0,
                  ),
                ],
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
                              'Hunt started:',
                              style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              startDate,
                              style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center,
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
                              'Game:',
                              style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
                                height: 60.0,
                                width: 330.0,
                                child: PokePicker(
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      game = gameList[value];
                                      _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
                                        {fbGame: game},
                                        SetOptions(merge: true),
                                      );
                                    });
                                  },
                                  controller: _gameController,
                                  sList: gameList,
                                  looping: true,
                                ),
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
                              'Rate:',
                              style: kDetailsTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
                                height: 60.0,
                                width: 100.0,
                                child: PokePicker(
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      rate = rateList[value];
                                      _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
                                        {fbRate: rate},
                                        SetOptions(merge: true),
                                      );
                                    });
                                  },
                                  controller: _rateController,
                                  sList: rateList,
                                  looping: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PokeInvertedIconButton(
                icon: Symbols.home_rounded,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                size: 44.0,
              ),
              const SizedBox(
                height: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getStartDate() {
    _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).get().then((value) {
      if (value.exists) {
        setState(() {
          startDate = value.data()?[fbStart];
          time = value.data()?[fbTime];
          _stopWatchTimer.setPresetTime(mSec: time!, add: true);
        });
      }
    });
  }
}
