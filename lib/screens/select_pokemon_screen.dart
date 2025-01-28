import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokemon_shiny_hunt/models/my_pokemon.dart';
import 'package:pokemon_shiny_hunt/screens/single_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/constants.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_grid_tile.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_picker.dart';

import '../widgets/poke_text_field_free.dart';

final _firestore = FirebaseFirestore.instance;

class SelectPokemonScreen extends StatefulWidget {
  static const String id = 'select_pokemon_screen';

  const SelectPokemonScreen({super.key});

  @override
  State<SelectPokemonScreen> createState() => _SelectPokemonScreenState();
}

class _SelectPokemonScreenState extends State<SelectPokemonScreen> {
  bool filterOn = false;
  bool searchOn = false;
  String search = '';
  String filter = genList.first;
  String filter2 = typeList.first;
  final TextEditingController _controller = TextEditingController();
  late final FixedExtentScrollController _genController;
  late final FixedExtentScrollController _typeController;

  @override
  void initState() {
    super.initState();
    _genController = FixedExtentScrollController(initialItem: 0);
    _typeController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _genController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokemon',
          style: kHeadline2TextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(
                8.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'ball',
                    child: SvgPicture.asset('images/colored_pokeball.svg', height: 100.0,)
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gen:',
                        style: kHeadline2TextStyle,
                      ),
                      SizedBox(
                        height: 60.0,
                        width: 100.0,
                        child: PokePicker(
                          onSelectedItemChanged: (value) {
                            setState(() {
                              filter = genList[value];
                            });
                          },
                          controller: _genController,
                          sList: genList,
                          looping: false,
                        ),
                      ),
                      const Text(
                        'Type:',
                        style: kHeadline2TextStyle,
                      ),
                      SizedBox(
                        height: 60.0,
                        width: 100.0,
                        child: PokePicker(
                          onSelectedItemChanged: (value) {
                            setState(() {
                              filter2 = typeList[value];
                            });
                          },
                          controller: _typeController,
                          sList: typeList,
                          looping: false,
                        ),
                      ),
                    ],
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
                      textEditingController: _controller,
                      obscureText: false,
                      keyboardType: TextInputType.name),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(fbPokemon).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MyPokemon> pokemonList = [];
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
                  switch (filter) {
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
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                      child: Material(
                        elevation: 4.0,
                        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8.0),
                            itemCount: pokemonList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PokeGridTile(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SinglePokemonScreen(
                                          pokemonList: pokemonList,
                                          index: index,
                                        );
                                      },
                                    ),
                                  );
                                },
                                leading: Image.asset(
                                  'pokemon/${pokemonList[index].id}_${pokemonList[index].name}_shiny.png',
                                ),
                                type: pokemonList[index].type,
                                type2: pokemonList[index].type2,
                                tag: '${pokemonList[index].id}select',
                                id: pokemonList[index].id,
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
