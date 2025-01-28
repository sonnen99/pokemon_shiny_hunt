import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/models/data_handler.dart';
import 'package:pokemon_shiny_hunt/screens/missing_shinies_screen.dart';
import 'package:pokemon_shiny_hunt/screens/profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/select_pokemon_screen.dart';
import 'package:pokemon_shiny_hunt/screens/settings_screen.dart';
import 'package:pokemon_shiny_hunt/screens/pokedex_screen.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../utilities/constants.dart';
import '../widgets/poke_inverted_icon_button.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'start_screen';

  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                 Theme.of(context).brightness == Brightness.dark ? 'images/peakpx.jpg': 'images/light_background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                screenList[currentIndex],
                style: kHeadline2TextStyle,
              ),
              automaticallyImplyLeading: false,
              actions: [
                if (currentIndex == 1)
                  PopupMenuButton(
                    icon: Icon(
                      Symbols.sort_rounded,
                      size: 36.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onSelected: (value) {
                      Provider.of<DataHandler>(context, listen: false).setSortValue(value);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    itemBuilder: (builder) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text(
                          'Poke Index',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text(
                          'Most encounters',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text(
                          'Least encounters',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text(
                          'Least time',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 4,
                        child: Text(
                          'Most time',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 5,
                        child: Text(
                          'Type',
                          style: kTextButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                if (currentIndex == 3)
                  SizedBox(
                    width: 60.0,
                    child: PokeInvertedIconButton(
                      icon: Symbols.settings_rounded,
                      onPressed: () {
                        Navigator.of(context).pushNamed(SettingsScreen.id);
                      },
                      size: 36.0,
                    ),
                  ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              heroTag: 'ball',
              onPressed: () {
                Navigator.pushNamed(context, SelectPokemonScreen.id);
              },
              shape: const CircleBorder(),
              child: SvgPicture.asset('images/colored_pokeball.svg'),

            ),
            extendBody: true,
            body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: const <Widget>[
                  HomeScreen(),
                  PokedexScreen(),
                  MissingShiniesScreen(),
                  ProfileScreen(),
                ]),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 14.0, left: 50.0, right: 50.0),
              child: SizedBox(
                height: 70.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: 1.0,
                      sigmaX: 1.0,
                    ),
                    child: CrystalNavigationBar(
                      marginR: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0.0),
                      paddingR: const EdgeInsets.all(0.0),
                      currentIndex: currentIndex,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      enableFloatingNavBar: true,
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      splashBorderRadius: 36.0,
                      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      enablePaddingAnimation: true,
                      outlineBorderColor: Theme.of(context).colorScheme.outline,
                      onTap: (value) {
                        setState(() {
                          currentIndex = value;
                          _pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
                        });
                      },
                      items: bottomBarList,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
