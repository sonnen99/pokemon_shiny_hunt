import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_switch.dart';
import 'package:provider/provider.dart';

import '../models/data_handler.dart';
import '../utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _notifications = true;
  String selectedLanguage = 'English';

  DropdownButton getDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < languageList.length; i++) {
      list.add(DropdownMenuItem(
        value: languageList[i],
        child: Text(languageList[i]),
      ));
    }
    return DropdownButton<String>(
      value: selectedLanguage,
      items: list,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
        });
      },
      style: kTextButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      borderRadius: BorderRadius.circular(20.0),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      isExpanded: false,
      isDense: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings', style: kHeadline2TextStyle,),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Language',
                  style: kHeadline2TextStyle,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                getDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark mode',
                  style: kHeadline2TextStyle,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                PokeSwitch(
                  activeIcon: Symbols.dark_mode_rounded,
                  inactiveIcon: Symbols.light_mode_rounded,
                  value: Provider.of<DataHandler>(context).mode == ThemeMode.dark,
                  onChanged: (value) {
                    setState(() {
                      Provider.of<DataHandler>(context, listen: false).toggleMode();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications',
                  style: kHeadline2TextStyle,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                PokeSwitch(
                  activeIcon: Symbols.notifications_active_rounded,
                  inactiveIcon: Symbols.notifications_off_rounded,
                  value: _notifications,
                  onChanged: (value) {
                    setState(() {
                      _notifications = value;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
