import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insurance_boost_app/services/auth.dart';
import 'package:insurance_boost_app/wrapper.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(StreamProvider<User?>.value(
    initialData: null,
    value: AuthService().user,
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insurance Booster App',
      home: Wrapper(),
    ),
  ));
}
