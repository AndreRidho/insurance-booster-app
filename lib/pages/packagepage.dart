import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatelessWidget {
  PackagePage({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> packages =
      FirebaseFirestore.instance.collection('packages').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Packages"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder(
          stream: packages,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong.");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return const Text("Connection done");
            }

            if (snapshot.connectionState == ConnectionState.active) {
              try {
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((package) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Congratulations!'),
                                    content: Text("You have subscribed to the \"" +
                                        package["name"] +
                                        "\" package. You will now be awarded with " +
                                        package["points"].toString() +
                                        " reward points, which you can redeem after three months."),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'))
                                    ],
                                  ));
                        },
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: package['name'] + '\n\n',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: package['description'] +
                                            '\n\nReward points given: '),
                                    TextSpan(
                                        text: package['points'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]))
                              // Text(
                              //   package['name'],
                              //   style: TextStyle(),
                              // ),
                              // const SizedBox(height: 10),
                              // Text(package['description']),
                              // Text('Reward points given: ' +
                              //     package['points'].toString())

                              ),
                        ),
                      ),
                    );
                  }).toList(),
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
      ),
    );
  }
}
