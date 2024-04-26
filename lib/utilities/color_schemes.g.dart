import 'dart:convert';

import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(4282343312),
  surfaceTint: Color(4282343312),
  onPrimary: Color(4294967295),
  primaryContainer: Color(4292207615),
  onPrimaryContainer: Color(4278197052),
  secondary: Color(4285553933),
  onSecondary: Color(4294967295),
  secondaryContainer: Color(4294762886),
  onSecondaryContainer: Color(4280490752),
  tertiary: Color(4279593812),
  onTertiary: Color(4294967295),
  tertiaryContainer: Color(4289000149),
  onTertiaryContainer: Color(4278198551),
  error: Color(4287646275),
  onError: Color(4294967295),
  errorContainer: Color(4294957781),
  onErrorContainer: Color(4282059015),
  background: Color(4294572543),
  onBackground: Color(4279835680),
  surface: Color(4294572543),
  onSurface: Color(4279835680),
  surfaceVariant: Color(4292928236),
  onSurfaceVariant: Color(4282599246),
  outline: Color(4285822847),
  outlineVariant: Color(4291086031),
  shadow: Color(4278190080),
  scrim: Color(4278190080),
  inverseSurface: Color(4281217077),
  inversePrimary: Color(4289251583),


);


const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(4289251583),
  surfaceTint: Color(4289251583),
  onPrimary: Color(4278595679),
  primaryContainer: Color(4280633207),
  onPrimaryContainer: Color(4292207615),
  secondary: Color(4292855149),
  onSecondary: Color(4282068736),
  secondaryContainer: Color(4283778304),
  onSecondaryContainer: Color(4294762886),
  tertiary: Color(4287157946),
  onTertiary: Color(4278204458),
  tertiaryContainer: Color(4278210878),
  onTertiaryContainer: Color(4289000149),
  error: Color(4294948011),
  onError: Color(4283833881),
  errorContainer: Color(4285740077),
  onErrorContainer: Color(4294957781),
  background: Color(4279309080),
  onBackground: Color(4292993769),
  surface: Color(4279309080),
  onSurface: Color(4292993769),
  surfaceVariant: Color(4282599246),
  onSurfaceVariant: Color(4291086031),
  outline: Color(4287533209),
  outlineVariant: Color(4282599246),
  shadow: Color(4278190080),
  scrim: Color(4278190080),
  inverseSurface: Color(4292993769),
  inversePrimary: Color(4282343312),


);

String getColor(BuildContext context, String color) {
  Color returnColor = const Color(0xFFFFFFFF);
  switch (Theme.of(context).brightness) {
    case Brightness.light:
      switch (color) {
        case 'blue':
          returnColor = const Color(0xFF395AAE);
          break;
        case 'green':
          returnColor = const Color(0xFF156D30);
          break;
        case 'brown':
          returnColor = const Color(0xFF855300);
          break;
        case 'pink':
          returnColor = const Color(0xFFA83156);
          break;
        case 'red':
          returnColor = const Color(0xFFC00100);
          break;
        case 'turquoise':
          returnColor = const Color(0xFF00687B);
          break;
        case 'violet':
          returnColor = const Color(0xFF6351A5);
          break;
        case 'yellow':
          returnColor = const Color(0xFFFBDB0F);
          break;
        case 'orange':
          returnColor = const Color(0xFFE47000);
          break;
        default:
          returnColor = const Color(0xFFFFFFFF);
          break;
      }
      break;
    case Brightness.dark:
      switch (color) {
        case 'blue':
          returnColor = const Color(0xFFB3C5FF);
          break;
        case 'green':
          returnColor = const Color(0xFF66DE8B);
          break;
        case 'brown':
          returnColor = const Color(0xFFC5Cf21);
          break;
        case 'pink':
          returnColor = const Color(0xFFFFB1C1);
          break;
        case 'red':
          returnColor = const Color(0xFFFF5540);
          break;
        case 'turquoise':
          returnColor = const Color(0xFF50D6F7);
          break;
        case 'violet':
          returnColor = const Color(0xFFCCBEFF);
          break;
        case 'yellow':
          returnColor = const Color(0xFFeffa4f);
          break;
        case 'orange':
          returnColor = const Color(0xFFFFB688);
          break;
        default:
          returnColor = const Color(0xFF000000);
          break;
      }
      break;
  }
  return jsonEncode('#${returnColor.value.toRadixString(16).substring(2)}');
}

String getLineColor(BuildContext context, String color) {
  Color returnColor = const Color(0xFFFFFFFF);

      switch (color) {

        case 'green':
          returnColor = const Color(0xFF85D98F);
          break;
        case 'yellow':
          returnColor = const Color(0xFFFBDB0F);
          break;
        case 'orange':
          returnColor = const Color(0xFFFC7D02);
          break;
        case 'red':
          returnColor = const Color(0xFFFD0100);
          break;
        default:
          returnColor = const Color(0xFFFFFFFF);
          break;
      }

  return jsonEncode('#${returnColor.value.toRadixString(16).substring(2)}');
}

Color getLineColorAsColor(BuildContext context, String color) {
  Color returnColor = const Color(0xFFFFFFFF);

  switch (color) {

    case 'green':
      returnColor = const Color(0xFF85D98F);
      break;
    case 'yellow':
      returnColor = const Color(0xFFFBDB0F);
      break;
    case 'orange':
      returnColor = const Color(0xFFFC7D02);
      break;
    case 'red':
      returnColor = const Color(0xFFFD0100);
      break;
    default:
      returnColor = const Color(0xFFFFFFFF);
      break;
  }

  return returnColor;
}