import 'package:flutter/material.dart';
import 'package:tag_n_go/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text("Log out"),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: Container());
  }
}
