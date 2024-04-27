import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';

import '../utilities/constants.dart';
import '../widgets/poke_elevated_button.dart';
import '../widgets/poke_text_field.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final storage = FlutterSecureStorage();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  bool inProgress = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        child: ModalProgressHUD(
          progressIndicator: SpinKitPulsingGrid(
            size: 80.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          inAsyncCall: inProgress,
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PokeTextField(
                  onChanged: (value) {
                    setState(() {
                      _emailController;
                    });
                    email = value;
                  },
                  labelText: 'Enter your email',
                  textEditingController: _emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                PokeTextField(
                  onChanged: (value) {
                    setState(() {
                      _passwordController;
                    });
                    password = value;
                  },
                  labelText: 'Enter your password',
                  textEditingController: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Hero(
                  tag: 'log_button',
                  child: PokeElevatedButton(
                    child: const Text(
                      'Register',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () async {
                      setState(() {
                        inProgress = true;
                      });
                      try {
                        final user = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
                        if (user != null) {
                          storage.write(key: stEmail, value: email.trim());
                          storage.write(key: stPassword, value: password.trim());
                          final fbUser = <String, dynamic>{
                            fbEmail: email,
                          };
                          _firestore.collection(fbUsers).add(fbUser).then((value) {
                            storage.write(key: stUID, value: value.id);
                          });
                          Navigator.pushNamedAndRemoveUntil(context, StartScreen.id, (route) => false);
                        }
                        setState(() {
                          inProgress = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                Hero(
                  tag: 'log_button',
                  child: PokeElevatedButton(
                    child: const Text(
                      'Cancel',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
