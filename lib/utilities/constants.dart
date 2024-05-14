import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  'Pokedex',
  'Settings',
  'Profile',
];

final languageList = <String>[
  'English',
  'Deutsch',
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

const kScreenTitleStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 24.0,);

const kButtonTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0,);

const kSurfaceTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0,);

const kErrorTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0,);

const kHeadline1TextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 32.0,);

const kHeadline2TextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 24.0,);

const kSubHeadlineTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0,);

const kEncounterNumberStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 100.0,);

const kStatsTileTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0,);

const kCupertinoTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 25.0,);