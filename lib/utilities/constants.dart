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
  Symbols.groups_rounded,
  Symbols.settings_rounded,
  Symbols.account_circle_rounded,
];

final screenList = <String>[
  'Home',
  'Team',
  'Settings',
  'Profile',
];

final languageList = <String> [
  'English',
  'Deutsch',
];

const kScreenTitleStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 24.0);

const kButtonTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0,);

const kSurfaceTextStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0);

const kErrorTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0);

const kHeadline1TextStyle = TextStyle(fontWeight: FontWeight.w400,fontSize: 32.0);

const kHeadline2TextStyle = TextStyle(fontWeight: FontWeight.w100,fontSize: 24.0);

const kSubHeadlineTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0);