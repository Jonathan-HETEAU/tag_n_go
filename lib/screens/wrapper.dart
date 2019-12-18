import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/screens/authenticate/authenticate.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null ? Authenticate() : Home();
  }
}
