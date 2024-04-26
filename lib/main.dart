import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_shiny_hunt/screens/home_screen.dart';
import 'package:pokemon_shiny_hunt/screens/profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/settings_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/screens/teams_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/firebase_options.dart';
import 'package:pokemon_shiny_hunt/utilities/theme_data.dart';
import 'package:provider/provider.dart';

import 'models/data_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataHandler(),
      child: Consumer<DataHandler>(builder: (_, model, __) {
        return MaterialApp(
          theme: MyTheme.lightThemeData(context),
          darkTheme: MyTheme.darkThemeData(),
          themeMode: model.mode,
          initialRoute: StartScreen.id,
          routes: {
            StartScreen.id: (context) => StartScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            TeamsScreen.id: (context) => TeamsScreen(),
            SettingsScreen.id: (context) => SettingsScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
          },
        );
      }),
    );
  }
}

