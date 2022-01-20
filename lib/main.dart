import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insurance_boost_app/pages/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Insurance Booster App',
    home: HomePage(),
  ));
}
