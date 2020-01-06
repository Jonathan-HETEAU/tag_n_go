import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/shared/date.dart';

class TagTile extends StatefulWidget {
  final Tag tag;
  final User user;
  final Function onDelete;

  TagTile({this.tag, this.user, this.onDelete});
  @override
  _TagTileState createState() => _TagTileState();
}

class _TagTileState extends State<TagTile> {
  bool isExpanded = false;

  Widget buttonDay(int index, String day, {bool selected = false}) {
    return RaisedButton(
      elevation: selected ? 5 : 1,
      child: Text(day[0],
          style: TextStyle(
              fontFamily: "BigSnow",
              fontSize: 15,
              color: selected ? Colors.white : AppColors.color5)),
      onPressed: () {
        widget.tag.days[index] = !widget.tag.days[index];
        widget.user.updateTag(widget.tag);
      },
      color: selected ? AppColors.color5 : Colors.white,
      shape: CircleBorder(),
    );
  }

  Widget week(List<bool> selectedDays) {
    return Container(
        child: Row(
            children: DateUtile.Days.asMap()
                .map((index, day) {
                  return MapEntry(
                      day,
                      Flexible(
                        flex: 1,
                        child: buttonDay(index, day,
                            selected: selectedDays[index]),
                      ));
                })
                .values
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: isExpanded ? Colors.white : Colors.white.withAlpha(200),
        child: ExpansionTile(
          trailing: isExpanded
              ? Icon(Icons.keyboard_arrow_up, color: AppColors.color2)
              : Icon(Icons.keyboard_arrow_down, color: AppColors.color5),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (val) => setState(() {
            isExpanded = val;
          }),
          title: AutoSizeText(
            '#' + widget.tag.name,
            style: TextStyle(
                fontFamily: "BigSnow",
                fontSize: 25,
                color: isExpanded ? AppColors.color5 : AppColors.color2),
            maxLines: 1,
          ),
          children: <Widget>[
            week(widget.tag.days),
            FlatButton.icon(
              label: AutoSizeText(
                "Delete " + widget.tag.name,
                style: TextStyle(
                    fontFamily: "BigSnow",
                    fontSize: 15,
                    color: AppColors.color3),
                maxLines: 1,
              ),
              icon: Icon(Icons.delete, color: AppColors.color3),
              onPressed: () => widget.onDelete(widget.tag),
            )
          ],
        ));
  }
}
