import 'package:flutter/material.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/shared/loading.dart';

class ModalTag extends StatelessWidget {
  final Tag tag;
  final Function onClose;
  final Function onChange;
  ModalTag({this.tag, this.onClose, this.onChange});

  @override
  Widget build(BuildContext context) {
    TagDay tagsToday = Provider.of<TagDay>(context);
    return tagsToday == null
        ? Loading()
        : Hero(
            tag: "tag",
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                    child: RaisedButton(
                        onPressed: onClose,
                        color: Colors.black.withAlpha(128))),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 150.0,
                    horizontal: 50.0,
                  ),
                  child: Card(
                      elevation: 10,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Text(tag.name),
                          Switch(
                            value: tagsToday.tags.contains(tag.name),
                            onChanged: (bool status) {
                              if (status) {
                                tagsToday.tags.add(tag.name);
                              } else {
                                tagsToday.tags.remove(tag.name);
                              }
                              onChange(tagsToday);
                            },
                          )
                        ],
                      )),
                )
              ],
            ));
  }
}
