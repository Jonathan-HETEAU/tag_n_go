import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';

class TodayGrid extends StatelessWidget {
  final Function onSelected;

  TodayGrid({this.onSelected});

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<List<Tag>>(context);
    TagDay tagsToday = Provider.of<TagDay>(context);
    int day = DateTime.now().weekday - 1;
   

    return tags == null || tagsToday == null
        ? Container()
        : GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children:
                tags.where((tag) => tag.activated && tag.days[day]).map((tag) {
              return Hero(
                  tag: "tag1",
                  child: RaisedButton(
                      color: tagsToday.tags.contains(tag.name)
                          ? Colors.blue
                          : Colors.red,
                      onPressed: () => onSelected(tag),
                      child: Center(
                        child: Text(
                          tag.name,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      )));
            }).toList(),
          );
  }
}
