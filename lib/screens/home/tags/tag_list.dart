import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/screens/home/tags/tag_tile.dart';
import 'package:tag_n_go/shared/dialog.dart';

class TagList extends StatefulWidget {
  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<List<Tag>>(context);
    final user = Provider.of<User>(context);
    return ListView.builder(
      itemCount: tags == null ? 0 : tags.length,
      itemBuilder: (context, index) {
        return TagTile(
            tag: tags[index],
            user: user,
            onDelete: (Tag tag) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return YesNoDialoq(
                        title: "Delete #" + tag.name,
                        onNo: () => Navigator.pop(context),
                        onYes: () async {
                          await user.deleteTag(tag);
                          Navigator.pop(context);
                        });
                  });
            });
      },
    );
  }
}
