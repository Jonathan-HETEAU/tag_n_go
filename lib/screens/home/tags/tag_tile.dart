import 'package:flutter/material.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/shared/dialog.dart';

class TagTile extends StatelessWidget {
  final Tag tag;
  final User user;
  final Function onDelete;
  TagTile({this.tag, this.user, this.onDelete});

  Widget buttonDay(int index, String day, {bool selected = false}) {
    return RaisedButton(
      child: Text(day[0]),
      onPressed: () {
        tag.days[index] = !tag.days[index];
        user.updateTag(tag);
      },
      color: selected ? Colors.blue : Colors.black,
      shape: CircleBorder(),
    );
  }

  static final List<String> Days = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimange"
  ];

  Widget week(List<bool> selectedDays) {
    return Container(
        child: Row(
            children: Days.asMap()
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
        child: ExpansionTile(
      title: Text(
        '#' + tag.name,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      children: <Widget>[
        week(tag.days),
        RaisedButton(
          child: Text("delete"),
          onPressed: () => onDelete(tag),
        )
      ],
    ));
  }
}
