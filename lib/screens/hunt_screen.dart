import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_inversed_icon_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field_free.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../utilities/color_schemes.g.dart';
import '../utilities/constants.dart';
import '../widgets/poke_delete_alert.dart';

final _firestore = FirebaseFirestore.instance;
final storage = const FlutterSecureStorage();

class HuntScreen extends StatefulWidget {
  static const String id = 'hunt_screen';
  final String PID;
  final String name;
  final String type;
  final String UID;
  final String rate;

  const HuntScreen({required this.PID, required this.name, required this.type, required this.UID, required this.rate});

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> with TickerProviderStateMixin {
  int encounter = 0;
  String startDate = '';
  String nickname = '';
  late String rate = widget.rate;
  int? time;
  bool caught = false;
  final TextEditingController _controller = TextEditingController();
  late final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
  );
  late final AnimationController _buttonAnimationController;
  late final AnimationController _starAnimationController;

  DropdownButton getRateDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < rateList.length; i++) {
      list.add(DropdownMenuItem(
        value: rateList[i],
        child: Text(rateList[i]),
      ));
    }
    return DropdownButton<String>(
      padding: const EdgeInsets.all(10.0),
      value: rate,
      items: list,
      onChanged: (value) {
        setState(() {
          rate = value!;
          _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
            {fbRate: rate},
            SetOptions(merge: true),
          );
        });
      },
      style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      borderRadius: BorderRadius.circular(10.0),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      isExpanded: true,
      isDense: true,
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _starAnimationController.dispose();
    _controller.dispose();
    _stopWatchTimer.onStopTimer();
    time = _stopWatchTimer.rawTime.value;
    _stopWatchTimer.dispose();
    if (!caught) {
      _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
        {fbTime: time},
        SetOptions(merge: true),
      );
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
    );
    _starAnimationController = AnimationController(
      vsync: this,
    );
    getStartDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Current hunt',
          style: kScreenTitleStyle,
        ),
        actions: [
          SizedBox(
            width: 120.0,
            child: getRateDropdown(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/pokemon_battle_platform.png'),
              alignment: Alignment.topCenter,
            ),
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'pokemon/${widget.PID}_${widget.name}_shiny.png',
                          height: 240.0,
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
                    const Text(
                      'Encounter:',
                      style: kHeadline1TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PokeInvertedIconButton(
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
                                      style: kEncounterNumberStyle,
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
                        PokeInvertedIconButton(
                          icon: Symbols.add_rounded,
                          onPressed: () {
                            setState(
                              () {
                                encounter++;
                                _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).set(
                                  {fbEncounter: encounter},
                                  SetOptions(merge: true),
                                );
                              },
                            );
                          },
                          size: 60.0,
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: _stopWatchTimer.rawTime,
                      initialData: 0,
                      builder: (context, snapshot) {
                        time = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(time!);
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                displayTime,
                                style: kHeadline2TextStyle,
                              ),
                            ),
                          ],
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MaterialButton(
                      shape: const CircleBorder(),
                      onPressed: () {},
                      padding: const EdgeInsets.all(4.0),
                      color: Theme.of(context).colorScheme.tertiary,
                      disabledColor: Theme.of(context).colorScheme.surfaceVariant,
                      disabledElevation: 0,
                      child: const SizedBox(
                        height: 80.0,
                        width: 80.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _stopWatchTimer.onStopTimer();
                        time = _stopWatchTimer.rawTime.value;
                        _buttonAnimationController.forward();
                        Future.delayed(const Duration(milliseconds: 800), () async {
                          _buttonAnimationController.reset();
                         final result = await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => AlertDialog(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 8.0,
                                  right: 10.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Symbols.celebration_rounded,
                                        size: 30.0,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                      Text(
                                        'Congratulations you found a shiny pokemon',
                                        textAlign: TextAlign.center,
                                        style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        'Do you want to give a nickname?',
                                        textAlign: TextAlign.center,
                                        style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              content: PokeTextFieldFree(
                                onChanged: (value) {
                                  setState(() {
                                    nickname = value;
                                  });
                                },
                                labelText: 'Nickname',
                                textEditingController: _controller,
                                obscureText: false,
                                keyboardType: TextInputType.name,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    final DateTime now = DateTime.now();
                                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                    final String date = formatter.format(now);
                                    final newShiny = <String, dynamic>{
                                      fbPName: widget.name,
                                      fbEncounter: encounter,
                                      fbPID: widget.PID,
                                      fbType: widget.type,
                                      fbStart: startDate,
                                      fbEnd: date,
                                      fbNickname: '',
                                      fbTime: time,
                                      fbRate: rate,
                                    };
                                    setState(() {
                                      caught = true;
                                    });
                                    _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(widget.PID).set(newShiny);
                                    _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).delete();
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    'No',
                                    style: kButtonTextStyle.copyWith(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final DateTime now = DateTime.now();
                                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                    final String date = formatter.format(now);
                                    final newShiny = <String, dynamic>{
                                      fbPName: widget.name,
                                      fbEncounter: encounter,
                                      fbPID: widget.PID,
                                      fbType: widget.type,
                                      fbStart: startDate,
                                      fbEnd: date,
                                      fbNickname: nickname.trim(),
                                      fbTime: time,
                                      fbRate: rate,
                                    };
                                    setState(() {
                                      caught = true;
                                    });
                                    _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(widget.PID).set(newShiny);
                                    _firestore.collection(fbUsers).doc(widget.UID).collection(fbCurrentHunts).doc(widget.PID).delete();
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    'Yes',
                                    style: kButtonTextStyle.copyWith(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (result) {
                            _starAnimationController.forward();
                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                Navigator.pushNamedAndRemoveUntil(context, StartScreen.id, (route) => false);
                              },
                            );
                          }
                        });
                      },
                      child: Lottie.asset(
                        'animations/star_button.json',
                        fit: BoxFit.fill,
                        frameRate: FrameRate.max,
                        repeat: false,
                        animate: true,
                        width: 100.0,
                        height: 100.0,
                        controller: _buttonAnimationController,
                        onLoaded: (composition) {
                          _buttonAnimationController.duration = composition.duration;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Hunt started: $startDate',
                style: kHeadline2TextStyle,
                textAlign: TextAlign.center,
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
