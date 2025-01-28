import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_cancel_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_inverted_icon_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_modal_bottom_sheet.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_picker.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_save_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field_free.dart';

import '../models/my_pokemon.dart';
import '../utilities/tags.dart';
import '../widgets/poke_grid_tile.dart';
import '../widgets/poke_snack_bar.dart';
import '../widgets/poke_text_field.dart';

final _firestore = FirebaseFirestore.instance;

class AddShinyScreen extends StatefulWidget {
  final String UID;

  const AddShinyScreen({super.key, required this.UID});

  @override
  State<AddShinyScreen> createState() => _AddShinyScreenState();
}

class _AddShinyScreenState extends State<AddShinyScreen> {
  String search = '';
  String rate = rateList.first;
  String game = gameList.first;
  int encounter = 0;
  String nickname = '';
  int tapped_index = 0;
  Duration time = const Duration(milliseconds: 0);
  String selectedDay = '00';
  List<MyPokemon> pokemonList = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  late final FixedExtentScrollController _rateController;
  late final FixedExtentScrollController _gameController;

  @override
  void initState() {
    super.initState();
    _rateController = FixedExtentScrollController(initialItem: 0);
    _gameController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _rateController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  CupertinoPicker getDayDropdown() {
    List<Padding> list = [];
    for (int i = 0; i < dayList.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            dayList[i],
            style: kCupertinoTextStyle,
          ),
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedDay = dayList[selectedIndex];
        });
      },
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.85,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Text(
            pokemonList.isNotEmpty ? '#${pokemonList[tapped_index].id} ${pokemonList[tapped_index].name}' : 'Select pokemon',
            style: kHeadline2TextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          PokeTextFieldFree(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              labelText: 'Search',
              textEditingController: _controller3,
              obscureText: false,
              keyboardType: TextInputType.name),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(fbPokemon).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  pokemonList.clear();
                  for (var pokemon in snapshot.data!.docs) {
                    pokemonList.add(
                      MyPokemon(
                        id: pokemon[fbPID],
                        name: pokemon[fbPName],
                        type: pokemon[fbType],
                        type2: pokemon[fbTwoTypes] ? pokemon[fbType2] : '',
                        gen: pokemon[fbGen],
                      ),
                    );
                  }

                  if (search != '') {
                    pokemonList = pokemonList.where((element) => element.name.toLowerCase().contains(search)).toList();
                  }
                  pokemonList.sort((a, b) => a.id.compareTo(b.id));

                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(10),
                    itemCount: pokemonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool tapped = index == tapped_index;
                      return PokeGridTile(
                        onPress: () {
                          setState(() {
                            tapped_index = index;
                          });
                        },
                        leading: Image.asset(
                          'pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png',
                        ),
                        type: tapped ? 'selected' : pokemonList[index].type,
                        type2: tapped ? 'selected' : pokemonList[index].type2,
                        tag: pokemonList[index].id,
                        id: pokemonList[index].id,
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(
                    child: Lottie.asset(
                      'animations/pikachu_loading.json',
                      fit: BoxFit.fill,
                      frameRate: FrameRate.max,
                      repeat: true,
                      animate: true,
                      width: 200.0,
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PokeInvertedIconButton(
                    icon: Symbols.timer_rounded,
                    onPressed: () {
                      PokeModalBottomSheet.of(context).showBottomSheet(
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 220.0,
                                child: getDayDropdown(),
                              ),
                            ),
                            const Text(
                              'days',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white),
                            ),
                            Expanded(
                              flex: 6,
                              child: CupertinoTimerPicker(
                                itemExtent: 32.0,
                                initialTimerDuration: time,
                                onTimerDurationChanged: (value) {
                                  setState(() {
                                    time = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    size: 36.0,
                  ),
                  Text(
                    '$selectedDay:${time.toString().split('.').first.padLeft(8, "0")}',
                    style: kHeadline2TextStyle,
                  ),
                  SizedBox(
                    width: 100.0,
                    height: 60.0,
                    child: PokePicker(
                      onSelectedItemChanged: (value) {
                        setState(() {
                          rate = rateList[value];
                        });
                      },
                      controller: _rateController,
                      sList: rateList,
                      looping: true,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PokePicker(
              onSelectedItemChanged: (value) {
                setState(() {
                  game = gameList[value];
                });
              },
              controller: _gameController,
              sList: gameList,
              looping: true,
            ),
          ),
          PokeTextField(
            onChanged: (value) {
              setState(() {
                encounter = int.parse(value);
              });
            },
            labelText: 'Encounter',
            textEditingController: _controller,
            obscureText: false,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 4.0,
          ),
          PokeTextFieldFree(
            onChanged: (value) {
              setState(() {
                nickname = value;
              });
            },
            labelText: 'Nickname',
            textEditingController: _controller2,
            obscureText: false,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PokeCancelButton(),
              PokeSaveButton(
                onPress: encounter != 0
                    ? () {
                        if (encounter != 0 && rate != 'Rate' && game != 'Game') {
                          final DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final String date = formatter.format(now);
                          time += Duration(days: int.parse(selectedDay));
                          final newShiny = <String, dynamic>{
                            fbPName: pokemonList[tapped_index].name,
                            fbEncounter: encounter,
                            fbPID: pokemonList[tapped_index].id,
                            fbTwoTypes: pokemonList[tapped_index].type2 == '' ? false : true,
                            fbType: pokemonList[tapped_index].type,
                            fbType2: pokemonList[tapped_index].type2,
                            fbStart: date,
                            fbEnd: date,
                            fbNickname: nickname.trim(),
                            fbTime: time.inMilliseconds,
                            fbRate: rate,
                            fbGame: game,
                          };
                          _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(pokemonList[tapped_index].id).set(newShiny);
                          Navigator.pop(context, true);
                        } else {
                          if (encounter == 0) PokeSnackBar.of(context).showSnackBar('Encounter can not be 0', false);
                          if (rate == 'Rate') PokeSnackBar.of(context).showSnackBar('Please select a rate', false);
                          if (game == 'Game') PokeSnackBar.of(context).showSnackBar('Please select a game', false);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
