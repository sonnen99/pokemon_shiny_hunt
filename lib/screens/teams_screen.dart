import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';


final _firestore = FirebaseFirestore.instance;

class TeamsScreen extends StatefulWidget {
  static const String id = 'teams_screen';

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.small(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(),
                ),
              ),
            );
          },
          shape: const CircleBorder(),
          child: const Icon(
            Symbols.add_rounded,
            size: 32.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: const Column(
        children: [
          // AthleteStream(),
        ],
      ),
    );
  }
}

// class AthleteStream extends StatelessWidget {
//   const AthleteStream({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection(fbAthletes).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Athlete> athleteList = [];
//           for (var athlete in snapshot.data!.docs) {
//             athleteList.add(Athlete(
//                 firstName: athlete[fbFirstname],
//                 lastName: athlete[fbLastname],
//                 fbid: athlete.id,
//                 redArea: athlete[fbRedArea],
//                 yellowArea: athlete[fbYellowArea],
//                 greenArea: athlete[fbGreenArea]));
//           }
//           athleteList.sort((a, b) => a.firstName.compareTo(b.firstName));
//           return Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: athleteList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onLongPress: () {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: true,
//                       builder: (_) => PBDeleteAlert(
//                         title: 'Delete athlete?',
//                         content: '${athleteList[index].firstName} ${athleteList[index].lastName}',
//                         onYes: () {
//                           _firestore
//                               .collection(fbAthletes)
//                               .where(fbFirstname, isEqualTo: athleteList[index].firstName)
//                               .where(fbLastname, isEqualTo: athleteList[index].lastName)
//                               .get()
//                               .then((doc) {
//                             String id = doc.docs[0].id;
//                             _firestore.collection(fbAthletes).doc(id).collection(fbPerformances).get().then((value) {
//                               if (value.docs.isNotEmpty) {
//                                 for (var doc in value.docs) {
//                                   _firestore.collection(fbAthletes).doc(id).collection(fbPerformances).doc(doc.id).delete();
//                                 }
//                               }
//                             });
//                             _firestore.collection(fbAthletes).doc(id).delete();
//                           });
//                           Navigator.pop(context);
//                         },
//                       ),
//                     );
//                   },
//                   child: PBListTile(
//                     bleTitle: '${athleteList[index].firstName} ${athleteList[index].lastName}',
//                     onPress: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             List<int> limits = [];
//                             limits.add(athleteList[index].redArea);
//                             limits.add(athleteList[index].yellowArea);
//                             limits.add(athleteList[index].greenArea);
//                             return AthleteScreen(
//                               athleteID: athleteList[index].fbid,
//                               athleteName: '${athleteList[index].firstName} ${athleteList[index].lastName}',
//                               athleteLimits: limits,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     leading: const Icon(
//                       Symbols.person,
//                       size: 24.0,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return const Center(
//             child: SpinKitPulsingGrid(
//               size: 40.0,
//               color: Colors.blueAccent,
//             ),
//           );
//         }
//       },
//     );
//   }
// }
