import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/screens/profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/settings_screen.dart';
import 'package:pokemon_shiny_hunt/screens/teams_screen.dart';
import 'dart:ui';

import '../utilities/constants.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'start_screen';

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var currentIndex = 0;
  late PageController _pageController;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loginUser();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              screenList[currentIndex],
              style: kScreenTitleStyle,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            heroTag: 'performance',
            onPressed: () {
              //TODO navigate to shiny hunt page
            },
            shape: const CircleBorder(),
            child:  Image.asset('images/playstore.png', fit: BoxFit.cover, gaplessPlayback: true),
          ),
          extendBody: true,
          body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: <Widget>[
                HomeScreen(),
                TeamsScreen(),
                SettingsScreen(),
                ProfileScreen(),
              ]),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                child: AnimatedBottomNavigationBar(
                  iconSize: 40,
                  icons: iconList,
                  activeIndex: currentIndex,
                  onTap: (value) {
                    setState(() {
                      currentIndex = value;
                      _pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
                    });
                  },
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.softEdge,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                  activeColor: Theme.of(context).colorScheme.tertiary,
                  inactiveColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  elevation: 4.0,
                  splashColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> loginUser() async {
    String email = 'sonnen@gmail.com';
    String password = '123456';

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Registered');
    } catch (e) {
      print(e);
    }
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Logged in');

    } catch (e) {
      print(e);
    }

  }
}
