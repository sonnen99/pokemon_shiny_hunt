import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_inversed_icon_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field_free.dart';

import '../models/my_pokemon.dart';
import '../utilities/tags.dart';
import '../widgets/poke_grid_tile.dart';
import '../widgets/poke_text_field.dart';

final _firestore = FirebaseFirestore.instance;

class AddShinyScreen extends StatefulWidget {
  final String UID;

  const AddShinyScreen({required this.UID});

  @override
  State<AddShinyScreen> createState() => _AddShinyScreenState();
}

class _AddShinyScreenState extends State<AddShinyScreen> {
  String filter1 = genList.first;
  String filter2 = typeList.first;
  String rate = rateList.first;
  int encounter = 0;
  String nickname = '';
  int tapped_index = 0;
  Duration time = const Duration(milliseconds: 0);
  String selectedDay = '00';
  List<MyPokemon> pokemonList = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  DropdownButton getGenDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < genList.length; i++) {
      list.add(DropdownMenuItem(
        value: genList[i],
        child: Text(genList[i]),
      ));
    }
    return DropdownButton<String>(
      padding: const EdgeInsets.all(10.0),
      value: filter1,
      items: list,
      onChanged: (value) {
        setState(() {
          filter1 = value!;
        });
      },
      style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      borderRadius: BorderRadius.circular(10.0),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      isExpanded: true,
      isDense: true,
    );
  }

  DropdownButton getTypeDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < typeList.length; i++) {
      list.add(DropdownMenuItem(
        value: typeList[i],
        child: Text(typeList[i]),
      ));
    }
    return DropdownButton<String>(
      padding: const EdgeInsets.all(10.0),
      value: filter2,
      items: list,
      onChanged: (value) {
        setState(() {
          filter2 = value!;
        });
      },
      style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      borderRadius: BorderRadius.circular(10.0),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      isExpanded: true,
      isDense: true,
    );
  }

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
        });
      },
      style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      borderRadius: BorderRadius.circular(10.0),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      isExpanded: true,
      isDense: true,
    );
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
      height: MediaQuery.of(context).size.height / 1.5,
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Gen:',
                  style: kHeadline2TextStyle,
                ),
                Expanded(child: getGenDropdown()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Type:',
                  style: kHeadline2TextStyle,
                ),
                Expanded(child: getTypeDropdown()),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(fbPokemon).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  pokemonList.clear();
                  for (var pokemon in snapshot.data!.docs) {
                    pokemonList.add(MyPokemon(id: pokemon[fbPID], name: pokemon[fbPName], type: pokemon[fbType], gen: pokemon[fbGen]));
                  }
                  switch (filter1) {
                    case 'All':
                      break;
                    case 'Gen 1':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 1).toList();
                      break;
                    case 'Gen 2':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 2).toList();
                      break;
                    case 'Gen 3':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 3).toList();
                      break;
                    case 'Gen 4':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 4).toList();
                      break;
                    case 'Gen 5':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 5).toList();
                      break;
                    case 'Gen 6':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 6).toList();
                      break;
                    case 'Gen 7':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 7).toList();
                      break;
                    case 'Gen 8':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 8).toList();
                      break;
                    case 'Gen 9':
                      pokemonList = pokemonList.where((element) => int.parse(element.gen) == 9).toList();
                      break;
                  }
                  switch (filter2) {
                    case 'All':
                      break;
                    case 'bug':
                      pokemonList = pokemonList.where((element) => element.type == 'bug').toList();
                      break;
                    case 'dark':
                      pokemonList = pokemonList.where((element) => element.type == 'dark').toList();
                      break;
                    case 'dragon':
                      pokemonList = pokemonList.where((element) => element.type == 'dragon').toList();
                      break;
                    case 'electric':
                      pokemonList = pokemonList.where((element) => element.type == 'electric').toList();
                      break;
                    case 'fairy':
                      pokemonList = pokemonList.where((element) => element.type == 'fairy').toList();
                      break;
                    case 'fighting':
                      pokemonList = pokemonList.where((element) => element.type == 'fighting').toList();
                      break;
                    case 'fire':
                      pokemonList = pokemonList.where((element) => element.type == 'fire').toList();
                      break;
                    case 'flying':
                      pokemonList = pokemonList.where((element) => element.type == 'flying').toList();
                      break;
                    case 'ghost':
                      pokemonList = pokemonList.where((element) => element.type == 'ghost').toList();
                      break;
                    case 'grass':
                      pokemonList = pokemonList.where((element) => element.type == 'grass').toList();
                      break;
                    case 'ice':
                      pokemonList = pokemonList.where((element) => element.type == 'ice').toList();
                      break;
                    case 'normal':
                      pokemonList = pokemonList.where((element) => element.type == 'normal').toList();
                      break;
                    case 'poison':
                      pokemonList = pokemonList.where((element) => element.type == 'poison').toList();
                      break;
                    case 'psychic':
                      pokemonList = pokemonList.where((element) => element.type == 'psychic').toList();
                      break;
                    case 'rock':
                      pokemonList = pokemonList.where((element) => element.type == 'rock').toList();
                      break;
                    case 'steel':
                      pokemonList = pokemonList.where((element) => element.type == 'steel').toList();
                      break;
                    case 'water':
                      pokemonList = pokemonList.where((element) => element.type == 'water').toList();
                      break;
                  }
                  pokemonList.sort((a, b) => a.id.compareTo(b.id));

                  return Expanded(
                    child: GridView.builder(
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
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
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
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PokeInvertedIconButton(
                    icon: Symbols.timer_rounded,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            height: 216.0,
                            padding: const EdgeInsets.all(6.0),
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: getDayDropdown(),
                                ),
                                const Text(
                                  'days',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white),
                                ),
                                Expanded(
                                  flex: 4,
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
                          ),
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
                    width: 120.0,
                    child: getRateDropdown(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: PokeTextField(
                  onChanged: (value) {
                    setState(() {
                      encounter = int.parse(value);
                    });
                  },
                  labelText: 'Encounter',
                  textEditingController: _controller,
                  obscureText: false,
                  keyboardType: TextInputType.number),
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
                keyboardType: TextInputType.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
                PokeElevatedButton(
                  onPressed: encounter != 0
                      ? () {
                          final DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final String date = formatter.format(now);
                          time += Duration(days: int.parse(selectedDay));
                          final newShiny = <String, dynamic>{
                            fbPName: pokemonList[tapped_index].name,
                            fbEncounter: encounter,
                            fbPID: pokemonList[tapped_index].id,
                            fbType: pokemonList[tapped_index].type,
                            fbStart: date,
                            fbEnd: date,
                            fbNickname: nickname.trim(),
                            fbTime: time.inMilliseconds,
                            fbRate: rate,
                          };
                          _firestore.collection(fbUsers).doc(widget.UID).collection(fbShinies).doc(pokemonList[tapped_index].id).set(newShiny);
                          Navigator.pop(context, true);
                        }
                      : null,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.save_rounded,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Save',
                        style: kButtonTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
