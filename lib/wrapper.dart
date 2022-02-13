import 'package:flutter/material.dart';
import 'package:insurance_boost_app/pages/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either the Home or Authenticate widget
    return Authenticate();
  }
}
