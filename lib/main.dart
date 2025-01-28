import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pokemon_shiny_hunt/screens/home_screen.dart';
import 'package:pokemon_shiny_hunt/screens/login_screen.dart';
import 'package:pokemon_shiny_hunt/screens/profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/registration_screen.dart';
import 'package:pokemon_shiny_hunt/screens/select_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/screens/settings_screen.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/screens/pokedex_screen.dart';
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
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

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
            WelcomeScreen.id: (context) => const WelcomeScreen(),
            LoginScreen.id: (context) => const LoginScreen(),
            RegistrationScreen.id: (context) => const RegistrationScreen(),
            StartScreen.id: (context) => const StartScreen(),
            HomeScreen.id: (context) => const HomeScreen(),
            PokedexScreen.id: (context) => const PokedexScreen(),
            SettingsScreen.id: (context) => const SettingsScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
            SelectPokemonScreen.id: (context) => const SelectPokemonScreen(),
          },
        );
      }),
    );
  }
}

Future<bool> checkLogin() async {
  const storage = FlutterSecureStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? email = await storage.read(key: stEmail);
  String? password = await storage.read(key: stPassword);
  final List<ConnectivityResult> results = await (Connectivity().checkConnectivity());
  if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)){
    if (email != null && password != null) {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
  }
  return false;
}
