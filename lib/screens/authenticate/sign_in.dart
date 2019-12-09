import 'package:flutter/material.dart';
import 'package:tag_n_go/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tag_n_go/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errors = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: Text("Sign in #TagNgo"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Register"),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email',),
                  validator: (email) => !EmailValidator.validate(email)
                      ? 'Email incorrect'
                      : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password',),
                  obscureText: true,
                  validator: (password) => password.length < 6
                      ? 'Enter a password 6+ chars long '
                      : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.black26),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          errors = 'email or password is incorect';
                        });
                      }
                      print(email);
                      print(password);
                    } else {}
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(errors, style: TextStyle(color: Colors.red, fontSize: 14))
              ],
            ),
          )),
    );
  }
}
