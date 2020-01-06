import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/resources/app_colors.dart';
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
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('My Tags',
              style: TextStyle(
                  fontFamily: "BigSnow",
                  fontSize: 40,
                  color: AppColors.color5)),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.exit_to_app,
                color: AppColors.color2,
              ),
              label: Text("Log out",
                  style: TextStyle(
                      fontFamily: "BigSnow",
                      fontSize: 14,
                      color: AppColors.color2)),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  AppColors.color5,
                  AppColors.color4,
                  AppColors.color2
                ])),
            child: TagList()),
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          backgroundColor: Colors.white,
          child: Icon(Icons.add,color: AppColors.color5,size: 40,),
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
