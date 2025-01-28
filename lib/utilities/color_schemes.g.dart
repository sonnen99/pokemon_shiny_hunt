import 'dart:convert';

import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff406836),
  surfaceTint: Color(0xff406836),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffc0efaf),
  onPrimaryContainer: Color(0xff002200),
  secondary: Color(0xff446732),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffc5efab),
  onSecondaryContainer: Color(0xff072100),
  tertiary: Color(0xff725c0c),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffffe089),
  onTertiaryContainer: Color(0xff241a00),
  error: Color(0xff904a43),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad5),
  onErrorContainer: Color(0xff3b0907),
  surface: Color(0xfffdf9ec),
  onSurface: Color(0xff1c1c14),
  onSurfaceVariant: Color(0xff43483f),
  outline: Color(0xff73796e),
  outlineVariant: Color(0xffc3c8bc),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff323128),
  inversePrimary: Color(0xffa5d395),
  primaryFixed: Color(0xffc0efaf),
  onPrimaryFixed: Color(0xff002200),
  primaryFixedDim: Color(0xffa5d395),
  onPrimaryFixedVariant: Color(0xff295020),
  secondaryFixed: Color(0xffc5efab),
  onSecondaryFixed: Color(0xff072100),
  secondaryFixedDim: Color(0xffa9d291),
  onSecondaryFixedVariant: Color(0xff2d4f1c),
  tertiaryFixed: Color(0xffffe089),
  onTertiaryFixed: Color(0xff241a00),
  tertiaryFixedDim: Color(0xffe2c46d),
  onTertiaryFixedVariant: Color(0xff574500),
  surfaceDim: Color(0xffdedacd),
  surfaceBright: Color(0xfffdf9ec),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff8f4e6),
  surfaceContainer: Color(0xfff2eee0),
  surfaceContainerHigh: Color(0xffece8db),
  surfaceContainerHighest: Color(0xffe6e2d5),
);


const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffa5d395),
  surfaceTint: Color(0xffa5d395),
  onPrimary: Color(0xff11380b),
  primaryContainer: Color(0xff295020),
  onPrimaryContainer: Color(0xffc0efaf),
  secondary: Color(0xffa9d291),
  onSecondary: Color(0xff173807),
  secondaryContainer: Color(0xff2d4f1c),
  onSecondaryContainer: Color(0xffc5efab),
  tertiary: Color(0xffe2c46d),
  onTertiary: Color(0xff3d2f00),
  tertiaryContainer: Color(0xff574500),
  onTertiaryContainer: Color(0xffffe089),
  error: Color(0xffffb4ab),
  onError: Color(0xff561e19),
  errorContainer: Color(0xff73342d),
  onErrorContainer: Color(0xffffdad5),
  surface: Color(0xff14140c),
  onSurface: Color(0xffe6e2d5),
  onSurfaceVariant: Color(0xffc3c8bc),
  outline: Color(0xff8d9387),
  outlineVariant: Color(0xff43483f),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe6e2d5),
  inversePrimary: Color(0xff406836),
  primaryFixed: Color(0xffc0efaf),
  onPrimaryFixed: Color(0xff002200),
  primaryFixedDim: Color(0xffa5d395),
  onPrimaryFixedVariant: Color(0xff295020),
  secondaryFixed: Color(0xffc5efab),
  onSecondaryFixed: Color(0xff072100),
  secondaryFixedDim: Color(0xffa9d291),
  onSecondaryFixedVariant: Color(0xff2d4f1c),
  tertiaryFixed: Color(0xffffe089),
  onTertiaryFixed: Color(0xff241a00),
  tertiaryFixedDim: Color(0xffe2c46d),
  onTertiaryFixedVariant: Color(0xff574500),
  surfaceDim: Color(0xff14140c),
  surfaceBright: Color(0xff3a3930),
  surfaceContainerLowest: Color(0xff0f0e07),
  surfaceContainerLow: Color(0xff1c1c14),
  surfaceContainer: Color(0xff212018),
  surfaceContainerHigh: Color(0xff2b2a22),
  surfaceContainerHighest: Color(0xff36352c),
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
