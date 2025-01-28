import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/pokeball_icons.dart';

const kBottomIconData = IconThemeData(
  fill: 0,
  weight: 200,
  opticalSize: 48,
  grade: 200,
  size: 40,
);

const kIconData = IconThemeData(
  fill: 0,
  weight: 200,
  opticalSize: 48,
  grade: 200,
  size: 24,
);

final iconList = <IconData>[
  Symbols.home_rounded,
  Symbols.star_rounded,
  Symbols.settings_rounded,
  Symbols.account_circle_rounded,
];

final screenList = <String>[
  'Current hunts',
  'Shiny dex',
  'Missing shinies',
  'Profile',
];

final bottomBarList = <CrystalNavigationBarItem>[
  CrystalNavigationBarItem(icon: Symbols.home_rounded,),
  CrystalNavigationBarItem(icon: Pokeball.shiny_pokeball,),
  CrystalNavigationBarItem(icon: Pokeball.pokeball),
  CrystalNavigationBarItem(icon: Symbols.account_circle_rounded,),
];

final languageList = <String>[
  'English',
  'Deutsch',
];

final imageList = <String> [
  'playstore',
  'Abra',
  'Bellsprout',
  'Caterpie',
  'Chansey',
  'Clefairy',
  'Cloyster',
  'Cubone',
  'Dratini',
  'Drowzee',
  'Eevee',
  'Ekans',
  'Electabuzz',
  'Electrode',
  'Enton',
  'Goldeen',
  'Grimer',
  'Growlithe',
  'Hitmonchan',
  'Hitmonlee',
  'Horsea',
  'Jigglypuff',
  'Krabby',
  'Lapras',
  'Machoke',
  'Magicarp',
  'Magmar',
  'Magnemite',
  'Meowth',
  'Nidoran',
  'Oddish',
  'Paras',
  'Pidgey',
  'Pinsir',
  'Poliwag',
  'Ponyta',
  'Rattata',
  'Rhyhorn',
  'Sandshrew',
  'Scyther',
  'Shellder',
  'Snorlax',
  'Spearow',
  'Staryu',
  'Tangela',
  'Venonat',
  'Vulpix',
  'Weedle',
  'Weezing',
  'Zubat',
];

final genList = <String>[
  'All',
  'Gen 1',
  'Gen 2',
  'Gen 3',
  'Gen 4',
  'Gen 5',
  'Gen 6',
  'Gen 7',
  'Gen 8',
  'Gen 9',
];

final typeList = <String>[
  'All',
  'bug',
  'dark',
  'dragon',
  'electric',
  'fairy',
  'fighting',
  'fire',
  'flying',
  'ghost',
  'grass',
  'ground',
  'ice',
  'normal',
  'poison',
  'psychic',
  'rock',
  'steel',
  'water',
];

final rateList = <String>[
  'Rate',
  '1/64',
  '1/273',
  '1/292',
  '1/315',
  '1/341',
  '1/372',
  '1/409',
  '1/455',
  '1/512',
  '1/585',
  '1/683',
  '1/819',
  '1/1024',
  '1/1365',
  '1/2048',
  '1/2731',
  '1/4096',
  '1/8192',
];

final gameList = <String> [ //TODO add games
  'Game',
  'Red, Green',
  'Blue',
  'Yellow',
  'Gold, Silver',
  'Crystal',
  'Ruby, Sapphire',
  'FireRed, LeafGreen',
  'Emerald',
  'Diamond, Pearl',
  'Platinum',
  'HeartGold, SoulSilver',
  'Black, White',
  'Black 2, White 2',
  'X, Y',
  'Omega Ruby, Alpha Sapphire',
  'Sun, Moon',
  'Ultra Sun, Ultra Moon',
  'Let\'s Go, Pikachu!',
  'Sword, Shield',
  'Brilliant Diamond, Shining Pearl',
  'Legends: Arceus',
  'Scarlet, Violet',
  'Legends: Z-A'
];

final dayList = <String>[
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
];

const kEncounterLargeNumberStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 80.0,);

const kEncounterSmallNumberStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 60.0,);

const kHeadline1TextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,);

const kCupertinoTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 25.0,);

const kHeadline2TextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 24.0,);

const kPickerTextStyle = TextStyle(fontWeight: FontWeight.w200, fontSize: 24.0,);

const kErrorTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0,);

const kDetailsTextStyle = TextStyle(fontWeight: FontWeight.w200, fontSize: 20.0);

const kTextButtonTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0,);

const kElevatedButtonTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0,);

const kSurfaceTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0,);

const kTextFieldTextStyle = TextStyle(fontWeight: FontWeight.w200, fontSize: 16.0, height: 1.2,);

const kStatsTileTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0,);


