import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insurance_boost_app/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialMedia { facebook, twitter, email, linkedin, whatsapp }

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final AuthService _auth = AuthService();
  static final _formKey = GlobalKey<FormState>();
  String error = '';
  String email = '';
  final emailController = TextEditingController();

  final Stream<QuerySnapshot> referrals =
      FirebaseFirestore.instance.collection('referrals').snapshots();

  Future share(SocialMedia socialPlatform) async {
    const subject = 'New Insurance Booster App!';
    const text =
        'Have you ever wanted to take advantage of the benefits you can get with your insurance packages, but could not be bothered with going through long pages of terms and conditions? Our new App will fix that problem for you! ';
    final urlShare =
        Uri.encodeComponent('https://sartajsajidupm.wixsite.com/website');
    final urls = {
      SocialMedia.facebook:
          'https://www.facebook.com/sharer.php?u=$urlShare&t=$text',
      SocialMedia.twitter: 'https://twitter.com/share?url=$urlShare&text=$text',
      SocialMedia.email: 'mailto:?subject=$subject&body=$text\n\n$urlShare',
      SocialMedia.linkedin:
          'https://www.linkedin.com/shareArticle?url=$urlShare&title=$subject',
      SocialMedia.whatsapp: 'https://api.whatsapp.com/send?text=$text$urlShare'
    };
    final url = urls[socialPlatform]!;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void refer(String referring, String referred) async {
    CollectionReference referralsUpdate =
        FirebaseFirestore.instance.collection('referrals');

    CollectionReference usersUpdate =
        FirebaseFirestore.instance.collection('users');

    CollectionReference rewardsUpdate =
        FirebaseFirestore.instance.collection('rewards');

    var referredUsers =
        await usersUpdate.where('email', isEqualTo: referred).get();

    for (var referredUser in referredUsers.docs) {
      DocumentReference userUpdate =
          FirebaseFirestore.instance.doc('users/' + referredUser.id);

      userUpdate.update({'wasReferred': true});
    }

    referralsUpdate.add({'referring': referring, 'referred': referred});

    var dateNow = DateTime.now();
    rewardsUpdate.add({
      'amount': 50,
      'dateToRedeem': DateTime(dateNow.year, dateNow.month + 3, dateNow.day),
      'userId': referred
    });

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Congratulations!'),
              content: const Text(
                  "You have referred a friend of yours! They will receive 50 reward points."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  Widget buildPage(BuildContext context) {
    return StreamBuilder(
        stream: referrals,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration.collapsed(
                      hintText: "Enter a friend's e-mail"),
                  controller: emailController,
                ),
                const SizedBox(height: 20.0),
                Text(
                  error,
                  style: const TextStyle(fontSize: 14.0, color: Colors.red),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    child: const Text(
                      'Refer',
                    ),
                    onPressed: () async {
                      email = emailController.text;
                      String currentUser = _auth.email!;

                      if (_formKey.currentState!.validate()) {
                        final userSnapshot = await FirebaseFirestore.instance
                            .collection("users")
                            .get();

                        final allUserData =
                            userSnapshot.docs.map((doc) => doc.data()).toList();

                        bool userExists = false;

                        for (var userData in allUserData) {
                          //Check if referred user exists
                          if (userData['email'] == email) {
                            userExists = true;

                            //Check if user is referring to themself
                            if (currentUser != email) {
                              //Check if any referrals exist
                              if (snapshot.hasData) {
                                //Check if current user has referred the referred user before
                                bool hasReferred = false;
                                for (var referral in snapshot.data!.docs) {
                                  if (currentUser == referral["referring"] &&
                                      email == referral['referred']) {
                                    hasReferred = true;
                                    setState(() {
                                      error =
                                          'You have already referred to this user before!';
                                    });
                                  }
                                }

                                if (!hasReferred) {
                                  refer(currentUser, email);
                                  setState(() {
                                    error = "";
                                  });
                                }
                              } else {
                                refer(currentUser, email);
                                setState(() {
                                  error = "";
                                });
                              }
                            } else {
                              setState(() {
                                error = "You cannot refer yourself";
                              });
                            }
                          }
                        }

                        if (!userExists) {
                          setState(() {
                            error =
                                "Please enter valid credentials (existing e-mail)";
                          });
                        }
                      } else {
                        setState(() {
                          error =
                              'Please enter valid credentials (existing e-mail)';
                        });
                      }
                    }),
                const Expanded(child: SizedBox()),
                const Text(
                    "Share this app with your friends! They can refer you and you will get reward points."),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () => share(SocialMedia.facebook),
                  leading: const Icon(FontAwesomeIcons.facebook),
                  title: const Text('Share to Facebook'),
                ),
                ListTile(
                  onTap: () => share(SocialMedia.twitter),
                  leading: const Icon(FontAwesomeIcons.twitter),
                  title: const Text('Share to Twitter'),
                ),
                ListTile(
                  onTap: () => share(SocialMedia.whatsapp),
                  leading: const Icon(FontAwesomeIcons.whatsapp),
                  title: const Text('Share to WhatsApp'),
                ),
                ListTile(
                  onTap: () => share(SocialMedia.linkedin),
                  leading: const Icon(FontAwesomeIcons.linkedin),
                  title: const Text('Share to LinkedIn'),
                ),
                ListTile(
                  onTap: () => share(SocialMedia.email),
                  leading: const Icon(Icons.mail),
                  title: const Text('Share via e-mail'),
                ),
              ],
            ),
          );
        });
  }

  Future<bool> checkIfReferred() async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    final allUserData = userSnapshot.docs.map((doc) => doc.data()).toList();

    for (var userData in allUserData) {
      if (userData['wasReferred'] && userData['email'] == _auth.email) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Referrals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          future: checkIfReferred(),
          builder: (BuildContext context, AsyncSnapshot<bool> referSnapshot) {
            if (referSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (referSnapshot.connectionState == ConnectionState.done) {
              if (referSnapshot.hasError) {
                return const Text('Error');
              } else if (referSnapshot.hasData) {
                bool wasReferred = referSnapshot.data!;

                if (wasReferred) {
                  CollectionReference usersUpdate =
                      FirebaseFirestore.instance.collection('users');

                  List<QueryDocumentSnapshot<Object?>> thisUsers = [];
                  return FutureBuilder<QuerySnapshot>(
                      future: usersUpdate.get(), // async work
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> getAllUsersSnapshot) {
                        switch (getAllUsersSnapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text('Loading....');
                          default:
                            if (getAllUsersSnapshot.hasError) {
                              return Text(
                                  'Error: ${getAllUsersSnapshot.error}');
                            } else {
                              print(_auth.email);

                              thisUsers = getAllUsersSnapshot.data!.docs;

                              for (var thisUser in thisUsers) {
                                DocumentReference userUpdate = FirebaseFirestore
                                    .instance
                                    .doc('users/' + thisUser.id);

                                print("user: " + thisUser.id);

                                userUpdate.update({'wasReferred': false});
                              }

                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                print("showDialog shown");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Congratulations!'),
                                          content: const Text(
                                              "You have been referred by a friend! You have received 50 reward points."),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'))
                                          ],
                                        ));
                              });

                              return buildPage(context);
                            }
                        }
                      });
                } else {
                  return buildPage(context);
                }
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${referSnapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
