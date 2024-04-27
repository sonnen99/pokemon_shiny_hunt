import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pokemon_shiny_hunt/screens/home_screen.dart';
import 'package:pokemon_shiny_hunt/screens/login_screen.dart';
import 'package:pokemon_shiny_hunt/screens/profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/registration_screen.dart';
import 'package:pokemon_shiny_hunt/screens/settings_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/screens/collected_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/firebase_options.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/utilities/theme_data.dart';
import 'package:provider/provider.dart';

import 'models/data_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(isLoggedIn: await checkLogin(),));
}

class MyApp extends StatelessWidget {
  bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});

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
          initialRoute: isLoggedIn ? StartScreen.id : WelcomeScreen.id,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            StartScreen.id: (context) => StartScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            CollectedScreen.id: (context) => CollectedScreen(),
            SettingsScreen.id: (context) => SettingsScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
          },
        );
      }),
    );
  }
}

Future<bool> checkLogin() async {
  final storage = FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email = await storage.read(key: stEmail);
  String? password = await storage.read(key: stPassword);
  if (email != null && password != null) {
    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  }
  return false;
}
