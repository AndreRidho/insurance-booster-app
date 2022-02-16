import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insurance_boost_app/services/auth.dart';
import 'package:intl/intl.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> rewards =
        FirebaseFirestore.instance.collection('rewards').snapshots();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Reward Points'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: StreamBuilder(
            stream: rewards,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong.");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return const Text("Connection done");
              }

              if (snapshot.connectionState == ConnectionState.active) {
                try {
                  int totalPoints = 0;
                  int earliestPoints = 0;
                  DateTime earliestDate = DateTime(0);

                  for (var reward in snapshot.data!.docs) {
                    final userId = AuthService().email;

                    if (reward['userId'] == userId) {
                      totalPoints += reward['amount'] as int;
                      DateTime dateToRedeem = reward['dateToRedeem'].toDate();
                      if (dateToRedeem.day == earliestDate.day) {
                        earliestPoints += reward['amount'] as int;
                      } else if (dateToRedeem.day > earliestDate.day) {
                        earliestPoints = reward['amount'] as int;
                        earliestDate = dateToRedeem;
                      }
                    }
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "You have a total of " +
                            totalPoints.toString() +
                            " reward points, " +
                            earliestPoints.toString() +
                            " of which are able to be redeemed as of " +
                            DateFormat('yMMMMd').format(earliestDate) +
                            ".",
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const Image(image: AssetImage('assets/images/coins.png')),
                      Text(
                        totalPoints.toString(),
                        style:
                            const TextStyle(color: Colors.amber, fontSize: 75),
                      )
                    ],
                  );
                } on Exception catch (e) {
                  print(e);
                  return const Text("Something went wrong.");
                }
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return const Text("Loading");
            },
          ),
        ));
  }
}
