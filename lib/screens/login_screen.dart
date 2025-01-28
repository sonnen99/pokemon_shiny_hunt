import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pokemon_shiny_hunt/screens/start_screen.dart';
import 'package:pokemon_shiny_hunt/utilities/tags.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_elevated_button.dart';
import 'package:pokemon_shiny_hunt/widgets/poke_text_field.dart';

import '../widgets/poke_snack_bar.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
const storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/welcome_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          progressIndicator: Lottie.asset(
            'animations/pikachu_loading.json',
            fit: BoxFit.fill,
            frameRate: FrameRate.max,
            repeat: true,
            animate: true,
            width: 200.0,
          ),
          inAsyncCall: inProgress,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PokeElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Cancel',
                            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          const Icon(
                            Symbols.keyboard_arrow_right_rounded,
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Hero(
                      tag: 'log_button',
                      child: PokeElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Log in',
                              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            const Icon(
                              Symbols.keyboard_arrow_right_rounded,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            inProgress = true;
                          });
                          if (_emailController.value.text.isEmpty || _passwordController.value.text.isEmpty) {
                            setState(() {
                              inProgress = false;
                            });
                            PokeSnackBar.of(context).showSnackBar(_emailController.value.text.isEmpty ? 'Please enter Email' : 'Please enter Password', false);
                            return;
                          }
                          try {
                            await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
                            storage.write(key: stEmail, value: email.trim());
                            storage.write(key: stPassword, value: password.trim());
                            _firestore.collection(fbUsers).where(fbEmail, isEqualTo: email).get().then((value) {
                              storage.write(key: stUID, value: value.docs.first.id);
                              storage.write(key: stFirstName, value: value.docs.first.data()[fbFirstName]);
                              storage.write(key: stLastName, value: value.docs.first.data()[fbLastName]);
                              storage.write(key: stNickName, value: value.docs.first.data()[fbNickName]);
                              storage.write(key: stProfilePicture, value: value.docs.first.data()[fbProfilePicture]);
                              setState(() {
                                inProgress = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(context, StartScreen.id, (route) => false);
                            });

                          } catch (e) {
                            setState(() {
                              inProgress = false;
                            });
                            PokeSnackBar.of(context).showSnackBar(e.toString(), false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
