import 'dart:convert';

import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff3f5f90),
  surfaceTint: Color(0xff3f5f90),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffd5e3ff),
  onPrimaryContainer: Color(0xff001b3c),
  secondary: Color(0xff705d0d),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xfffce186),
  onSecondaryContainer: Color(0xff231b00),
  tertiary: Color(0xff156b54),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffa4f2d5),
  onTertiaryContainer: Color(0xff002117),
  error: Color(0xff904a43),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad5),
  onErrorContainer: Color(0xff3b0907),
  background: Color(0xfff9f9ff),
  onBackground: Color(0xff191c20),
  surface: Color(0xfff9f9ff),
  onSurface: Color(0xff191c20),
  surfaceVariant: Color(0xffe0e2ec),
  onSurfaceVariant: Color(0xff43474e),
  outline: Color(0xff74777f),
  outlineVariant: Color(0xffc4c6cf),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2e3035),
  inversePrimary: Color(0xffa8c8ff),


);


const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffa8c8ff),
  surfaceTint: Color(0xffa8c8ff),
  onPrimary: Color(0xff06305f),
  primaryContainer: Color(0xff254777),
  onPrimaryContainer: Color(0xffd5e3ff),
  secondary: Color(0xffdfc56d),
  onSecondary: Color(0xff3b2f00),
  secondaryContainer: Color(0xff554500),
  onSecondaryContainer: Color(0xfffce186),
  tertiary: Color(0xff88d6ba),
  onTertiary: Color(0xff00382a),
  tertiaryContainer: Color(0xff00513e),
  onTertiaryContainer: Color(0xffa4f2d5),
  error: Color(0xffffb4ab),
  onError: Color(0xff561e19),
  errorContainer: Color(0xff73342d),
  onErrorContainer: Color(0xffffdad5),
  background: Color(0xff111318),
  onBackground: Color(0xffe1e2e9),
  surface: Color(0xff111318),
  onSurface: Color(0xffe1e2e9),
  surfaceVariant: Color(0xff43474e),
  onSurfaceVariant: Color(0xffc4c6cf),
  outline: Color(0xff8e9099),
  outlineVariant: Color(0xff43474e),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe1e2e9),
  inversePrimary: Color(0xff3f5f90),


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
  Color returnColor = const Color(0xFF8E9099);

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

Color getTypeBackgroundColor(String type) {
  Color color = const Color(0x00000000);
  switch (type) {
    case 'bug':
      color = const Color(0xFFADBD21);
      break;
    case 'dark':
      color = const Color(0xFF735A4A);
      break;
    case 'dragon':
      color = const Color(0xFF695BA5);
      break;
    case 'electric':
      color = const Color(0xFFFFD464);
      break;
    case 'fairy':
      color = const Color(0xFFF7B5F7);
      break;
    case 'fighting':
      color = const Color(0xFFA55239);
      break;
    case 'fire':
      color = const Color(0xFFF75231);
      break;
    case 'flying':
      color = const Color(0xFF9CADF7);
      break;
    case 'ghost':
      color = const Color(0xFF6363B5);
      break;
    case 'grass':
      color = const Color(0xFF7ACB52);
      break;
    case 'ground':
      color = const Color(0xFFE2CC8D);
      break;
    case 'ice':
      color = const Color(0xFF5ACEE7);
      break;
    case 'normal':
      color = const Color(0xFFADA594);
      break;
    case 'poison':
      color = const Color(0xFFB55AA5);
      break;
    case 'psychic':
      color = const Color(0xFFFF73A5);
      break;
    case 'rock':
      color = const Color(0xFFBDA55A);
      break;
    case 'steel':
      color = const Color(0xFFADADC6);
      break;
    case 'water':
      color = const Color(0xFF399CFF);
      break;
    case 'selected':
      color = const Color(0xFF43474e);
      break;
  }
  return color;
}
