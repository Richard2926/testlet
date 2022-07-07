import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth.dart';

import 'package:testlet/ThemeRelated/background.dart';
import 'package:testlet/Backend/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.onSignedOut});

  final VoidCallback onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = AuthProvider.of(context).auth;
      //final AuthService auth = new AuthService();
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Background(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 350),
            child: FloatingActionButton.extended(
              onPressed: () =>
                  _signOut(context),
                //Navigator.pushNamed(context, upload-page),
              icon: new Image.asset('assets/google.png'),
              label: Text("Congrats you're in "),
            ),
          ),
        )
      ]),
    );
  }
}
