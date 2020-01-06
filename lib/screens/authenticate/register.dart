import 'package:flutter/material.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tag_n_go/shared/constants.dart';
import 'package:tag_n_go/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        colors: [
                      AppColors.color4,
                      AppColors.color5,
                      AppColors.color2
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
                                      validator: (password) => password.length <
                                              6
                                          ? 'Enter a password 6+ chars long '
                                          : null,
                                      obscureText: true,
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
                                    "Register !",
                                    style: TextStyle(
                                        fontFamily: "StreetStyle",
                                        color: Colors.white,
                                        fontSize: 30),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          errors = "Sorry, register fail !";
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  errors,
                                  style: TextStyle(
                                      color: AppColors.textDanger,
                                      fontSize: 14),
                                ),
                                FlatButton.icon(
                                  icon: Icon(
                                    Icons.keyboard_return,
                                    color: AppColors.color5,
                                  ),
                                  label: Text("Sign In",
                                      style:
                                          TextStyle(color: AppColors.color5)),
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
                    "Sign Up",
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
