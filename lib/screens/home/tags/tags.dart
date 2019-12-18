import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/screens/home/tags/tag_form.dart';
import 'package:tag_n_go/screens/home/tags/tag_list.dart';
import 'package:tag_n_go/services/auth.dart';
import 'package:tag_n_go/models/tag.dart';

class TagsView extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final tags = Provider.of<List<Tag>>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Tags'),
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
        body: TagList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
          tooltip: "'Add Tag",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_context) {
               
                return Container(
                  child: TagForm(
                    tags: tags,
                    onSubmit: (name) async {
                      await user.updateTag(Tag(name: name));
                      Navigator.pop(_context);
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
