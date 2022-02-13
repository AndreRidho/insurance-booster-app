import 'package:flutter/material.dart';
import 'package:insurance_boost_app/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Sign in'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration.collapsed(hintText: "E-mail"),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration:
                    const InputDecoration.collapsed(hintText: "Password"),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                error,
                style: const TextStyle(fontSize: 14.0, color: Colors.red),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  child: const Text(
                    'Sign in',
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  }),
              const SizedBox(height: 40.0),
              TextButton(
                onPressed: () async => widget.toggleView(),
                child: const Text("Create a new account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
