import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../utilities/constants.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: () {
            // showModalBottomSheet(
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (context) => SingleChildScrollView(
            //     child: Container(
            //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            //       TODO edit profile
            //     ),
            //   ),
            // );
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
                        backgroundImage: const AssetImage('images/medley.png'),
                        radius: 60.0,child: Padding(
                          padding: const EdgeInsets.only(left: 88.0, bottom: 88.0),
                          // child: PBInvertedIconButton(icon: Symbols.edit_rounded, onPressed: () {}, size: 24.0),
                        ),
                      ),
                    ),
                    Text(
                      'Medley',
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
                      'Name:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const Text(
                      'Jonathan Sonnen',
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Email: ',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const Text(
                      'jona@gmail.com',
                      style: kErrorTextStyle,
                    ),
                    Text(
                      'Phone:',
                      style: kHeadline2TextStyle.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const Text(
                      '+46 1234567890',
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
                    //TODO logout
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
}
