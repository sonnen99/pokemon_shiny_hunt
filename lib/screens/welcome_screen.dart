import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_shiny_hunt/screens/registration_screen.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';

import '../utilities/constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/welcome_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              isConnected
                  ? const SizedBox()
                  : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Theme.of(context).colorScheme.error,),
                    child: Text(
                      'Offline',
                      textAlign: TextAlign.center,
                      style: kStatsTileTextStyle.copyWith(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
              SizedBox(
                height: 240.0,
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      animatedTexts: [
                        ScaleAnimatedText('Gotta'),
                        ScaleAnimatedText('Catch \' Em'),
                        ScaleAnimatedText('ALL'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'log_button',
                    child: PokeElevatedButton(
                      child: const Text(
                        'Log in',
                        style: kButtonTextStyle,
                      ),
                      onPressed: () {
                        //Go to login screen.
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ),
                  Hero(
                    tag: 'reg_button',
                    child: PokeElevatedButton(
                      child: const Text(
                        'Register',
                        style: kButtonTextStyle,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkConnection() async {
    final List<ConnectivityResult> results = await (Connectivity().checkConnectivity());
    if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
      setState(() {
        isConnected = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        checkConnection();
      });
    }
    setState(() {
      isConnected = false;
    });
  }
}
