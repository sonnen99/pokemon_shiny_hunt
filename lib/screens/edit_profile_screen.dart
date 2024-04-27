import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field.dart';

import '../utilities/constants.dart';

final _firestore = FirebaseFirestore.instance;

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String firstName;
  final String lastName;
  final String nickName;

  const EditProfileScreen({required this.uid, required this.firstName, required this.lastName, required this.nickName});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String firstName = widget.firstName;
  late String lastName = widget.lastName;
  late String nickName = widget.nickName;
  late final _firstController = TextEditingController(text: firstName);
  late final _secondController = TextEditingController(text: lastName);
  late final _thirdController = TextEditingController(text: nickName);

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Edit profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            PokeTextField(
              labelText: 'First name',
              onChanged: (value) {
                setState(() {
                  _firstController;
                });
                firstName = value;
                print(value);
              },
              textEditingController: _firstController,
              obscureText: false,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 10.0,
            ),
            PokeTextField(
              labelText: 'Last name',
              onChanged: (value) {
                setState(() {
                  _secondController;
                });
                lastName = value;
                print(value);
              },
              textEditingController: _secondController, obscureText: false, keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 10.0,
            ),
            PokeTextField(
              labelText: 'Nick name',
              onChanged: (value) {
                setState(() {
                  _thirdController;
                });
                nickName = value;
                print(value);
              },
              textEditingController: _thirdController, obscureText: false, keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: kButtonTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
                PokeElevatedButton(
                  onPressed: () {
                    if (_firstController.value.text.isNotEmpty && _secondController.value.text.isNotEmpty && _thirdController.value.text.isNotEmpty) {
                      final user = <String, dynamic>{
                        fbFirstName: firstName.trim(),
                        fbLastName: lastName.trim(),
                        fbNickName: nickName.trim(),
                      };
                      print('UID: ${widget.uid}');
                      _firestore.collection(fbUsers).doc(widget.uid).update(user);
                      Navigator.pop(context, [firstName, lastName, nickName]);
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.save_rounded,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Save',
                        style: kButtonTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
