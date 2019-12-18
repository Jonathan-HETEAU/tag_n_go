import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/tag.dart';
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text("Create new #"),
          SizedBox(
            height: 20.0,
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
              color: Colors.green,
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.black26),
              ),
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
    );
  }
}
