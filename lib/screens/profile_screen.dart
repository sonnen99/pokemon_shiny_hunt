import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/screens/edit_profile_screen.dart';
import 'package:pokemon_shiny_hunt/screens/welcome_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import '../utilities/constants.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = FlutterSecureStorage();
  String email = '';
  String firstName = '';
  String lastName = '';
  String nickName = '';
  String id = '';

  @override
  void initState() {

    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: id == '' ? null : () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: EditProfileScreen(uid: id, firstName: firstName, lastName: lastName, nickName: nickName,),
                ),
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
          heroTag: 'performance',
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
                    const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: const AssetImage('images/playstore.png'),
                        radius: 60.0,child: Padding(
                          padding: const EdgeInsets.only(left: 88.0, bottom: 88.0),
                          // child: PBInvertedIconButton(icon: Symbols.edit_rounded, onPressed: () {}, size: 24.0),
                        ),
                      ),
                    ),
                    Text(
                      nickName,
                      style: kHeadline1TextStyle. copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trainer:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      '$firstName $lastName',
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Email: ',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      email,
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Shiny count:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      '1',
                      style: kSubHeadlineTextStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
                child: TextButton(
                  onPressed: () {
                    storage.deleteAll();
                    Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.logout_rounded,),
                      SizedBox(width: 4.0,),
                      Text(
                        'Logout',
                        style: kErrorTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0, left: 10.0),
                child: TextButton(
                  onPressed: () {
                    //TODO delete profile
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.delete_rounded, color: Theme.of(context).colorScheme.error,),
                      const SizedBox(width: 4.0,),
                      Text(
                        'Delete',
                        style: kErrorTextStyle.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Future<void> getInfo() async {
    email = (await storage.read(key: stEmail))!;
    id = (await storage.read(key: stUID))!;
    setState(() {
      email;
      id;
    });
    firstName = (await storage.read(key: stFirstName))!;
    lastName = (await storage.read(key: stLastName))!;
    nickName = (await storage.read(key: stNickName))!;
    setState(() {
      firstName;
      lastName;
      nickName;
    });
  }


}
