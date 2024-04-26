import 'package:flutter/material.dart';

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
      create: (context) => RawDataHandler(),
      child: Consumer<RawDataHandler>(builder: (_, model, __) {
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
            BarChartScreen.id: (context) => BarChartScreen(),
            SensorScreen.id: (context) => SensorScreen(),
          },
        );
      }),
    );
  }
}

