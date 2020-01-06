import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/shared/constants.dart';

class TagForm extends StatefulWidget {
  final List<Tag> tags;
  final Function onSubmit;
  TagForm({Key key, this.tags, this.onSubmit}) : super(key: key);

  @override
  _TagFormState createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String _currentName = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              AppColors.color5,
              AppColors.color4,
              AppColors.color1
            ])),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Create new #",
                  style: TextStyle(
                      fontFamily: "BigSnow",
                      fontSize: 40,
                      color: Colors.white)),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: '#',
                ),
                validator: (name) =>
                    widget.tags.map((tag) => tag.name).contains(name)
                        ? 'the tag already exists'
                        : null,
                onChanged: (name) {
                  setState(() {
                    _currentName = name;
                  });
                },
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: AppColors.color5, width: 5)),
                  color: Colors.white,
                  child: Text('Go',
                      style: TextStyle(
                          fontFamily: "BigSnow",
                          fontSize: 30,
                          color: AppColors.color5)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      await widget.onSubmit(_currentName);

                      setState(() {
                        loading = false;
                      });
                    }
                  }),
            ],
          ),
        ));
  }
}
