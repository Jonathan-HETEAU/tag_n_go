import 'package:flutter/material.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tag_n_go/shared/constants.dart';
import 'package:tag_n_go/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String errors = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.bottomLeft, colors: [
                  AppColors.color1,
                  AppColors.color4,
                  AppColors.color5,
                ])),
              ),
              Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(vertical: 120.0, horizontal: 50.0),
                  child: Card(
                      elevation: 15,
                      child: Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 70.0,
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    child: TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                        hintText: 'Email',
                                      ),
                                      validator: (email) =>
                                          !EmailValidator.validate(email)
                                              ? 'Email incorrect'
                                              : null,
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    child: TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                        hintText: 'Password',
                                      ),
                                      obscureText: true,
                                      validator: (password) => password.length <
                                              6
                                          ? 'Enter a password 6+ chars long '
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          password = val;
                                        });
                                      },
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                  color: AppColors.color5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 4)),
                                  child: Text(
                                    "Go",
                                    style: TextStyle(
                                        fontFamily: "StreetStyle",
                                        color: Colors.white,
                                        fontSize: 25),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          errors =
                                              'email or password is incorect';
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(errors,
                                    style: TextStyle(
                                        color: AppColors.textDanger,
                                        fontSize: 14)),
                                FlatButton.icon(
                                  icon: Icon(
                                    Icons.person_add,
                                    color: AppColors.color5,
                                  ),
                                  label: Text(
                                    "Register",
                                    style: TextStyle(color: AppColors.color5),
                                  ),
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                )
                              ],
                            ),
                          )))),
              Align(
                  alignment: Alignment(0, -0.7), //Alignment.topCenter,
                  child: Container(
                      child: Text(
                    "TagNgo",
                    style: TextStyle(
                        fontFamily: "StreetStyle",
                        color: Colors.white,
                        fontSize: 50),
                  ))),
              Align(
                alignment: Alignment(0, -0.55), //Alignment.topCenter,
                child: Container(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: "BigSnow"),
                  ),
                ),
              )
            ]));
  }
}
