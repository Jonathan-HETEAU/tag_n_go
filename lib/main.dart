import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/screens/wrapper.dart';
import 'package:tag_n_go/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userStream = AuthService().user;
    return (userStream != null)
        ? StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper(),
            ))
        : MaterialApp(
            home: Wrapper(),
          );
  }
}
