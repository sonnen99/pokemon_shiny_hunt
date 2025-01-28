import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/screens/edit_profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_modal_bottom_sheet.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_button.dart';
import 'package:pokemon_shiny_hunt/widgets/profile_grid_tile.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../utilities/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = const FlutterSecureStorage();
  final _controller = SuperTooltipController();
  String email = '';
  String firstName = '';
  String lastName = '';
  String nickName = '';
  String id = '';
  String profilePicture = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton.small(
          onPressed: id.isEmpty
              ? null
              : () async {
                  final result = await PokeModalBottomSheet.of(context).showBottomSheet(
                    EditProfileScreen(
                      uid: id,
                      firstName: firstName,
                      lastName: lastName,
                      nickName: nickName,
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      firstName = result[0];
                      lastName = result[1];
                      nickName = result[2];
                      storage.write(key: stFirstName, value: firstName);
                      storage.write(key: stLastName, value: lastName);
                      storage.write(key: stNickName, value: nickName);
                    });
                  }
                },
          shape: const CircleBorder(),
          child: const Icon(
            Symbols.edit_note_rounded,
            size: 30.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async {
                          _controller.showTooltip();
                        },
                        child: SuperTooltip(
                          arrowBaseWidth: 50.0,
                          arrowLength: 40.0,
                          arrowTipDistance: 20.0,
                          borderRadius: 30.0,
                          bottom: 200.0,
                          closeButtonColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          closeButtonSize: 36.0,
                          showCloseButton: true,
                          closeButtonType: CloseButtonType.inside,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          showBarrier: true,
                          controller: _controller,
                          content: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: GridView(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              children: getProfilePictures(),
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(profilePicture != '' ? 'images/$profilePicture.png' : 'images/playstore.png'),
                            radius: 60.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        nickName,
                        style: kHeadline1TextStyle.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Material(
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trainer:',
                              style: kCupertinoTextStyle.copyWith(color: Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              firstName != '' ? '$firstName $lastName' : '',
                              style: kSurfaceTextStyle,
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            Text(
                              'Email: ',
                              style: kCupertinoTextStyle.copyWith(color: Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              email,
                              style: kSurfaceTextStyle,
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(),
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PokeTextButton(
                onPressed: () {
                  _auth.signOut();
                  storage.deleteAll();
                  Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
                },
                icon: Symbols.logout_rounded,
                text: 'Logout',
              ),
              PokeTextButton(
                onPressed: () {
                  //TODO delete profile
                },
                icon: Symbols.delete_rounded,
                text: 'Delete',
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Future<void> getInfo() async {
    email = (await storage.read(key: stEmail))!;
    id = (await storage.read(key: stUID))!;
    if (mounted) {
      setState(() {
        email;
        id;
      });
    }
    firstName = (await storage.read(key: stFirstName))!;
    lastName = (await storage.read(key: stLastName))!;
    nickName = (await storage.read(key: stNickName))!;
    profilePicture = (await storage.read(key: stProfilePicture))!;
    if (mounted) {
      setState(() {
        firstName;
        lastName;
        nickName;
        profilePicture;
      });
    }
  }

  List<Widget> getProfilePictures() {
    List<Widget> gridList = [];
    for (var image in imageList) {
      gridList.add(
        ProfileGridTile(
            onPress: () {
              storage.write(key: stProfilePicture, value: image);
              _controller.hideTooltip();
              setState(() {
                profilePicture = image;
              });
            },
            image: 'images/$image.png'),
      );
    }
    return gridList;
  }
}
