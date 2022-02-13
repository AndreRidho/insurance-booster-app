import 'package:flutter/material.dart';
import 'package:insurance_boost_app/pages/authentication/register.dart';
import 'package:insurance_boost_app/pages/authentication/sign_in.dart';
import 'package:insurance_boost_app/pages/home.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
