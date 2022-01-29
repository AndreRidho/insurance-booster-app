import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Login_ui/authentication_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isVisible = false;

  fetchCredentials() {
    var username = "username";
    var password = "password123";
    return [username, password];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 200,
            ),

            // Login text Widget
            Center(
              child: Container(

                height: 200,
                width: 400,
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(
              height: 60,
              width: 10,
            ),

            // Wrong Password text
            Visibility(
              visible: _isVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Wrong credentials entered",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

            // Textfields for username and password fields
            Container(
              height: 140,
              width: 530,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onTap: () {

                    },
                    controller: emailController, // Controller for Username
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Username",
                        contentPadding: EdgeInsets.all(20)),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  TextFormField(
                    onTap: () {
                    },

                    controller: passwordController, // Controller for Password
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        contentPadding: EdgeInsets.all(20),
                        // Adding the visibility icon to toggle visibility of the password field
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {

                          },
                        )),
                    obscureText: _isObscure,
                  ),
                ],
              ),
            ),

            // Submit Button
            Container(
              width: 570,
              height: 70,
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                },
                child: Text("Sign in"),
              ),
            ),
          ],
        ));
  }
}

