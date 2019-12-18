import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/shared/date.dart';

class HistoryList extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  HistoryList({this.from, this.to});

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  String tagSelected = "";

  @override
  Widget build(BuildContext context) {
    List<TagDay> days = Provider.of<List<TagDay>>(context);
    Map<int, TagDay> dateDays = Map<int, TagDay>();
    Set<String> tags = Set();
    if (days != null) {
      dateDays.addEntries(days.where((tagDay) {
        if (tagDay.tags.isNotEmpty) {
          tags.addAll(tagDay.tags);
          return (tagSelected == "" || tagDay.tags.contains(tagSelected));
        } else {
          return false;
        }
      }).map((tagDay) {
        return MapEntry(
            widget.from.difference(tagDay.date).inDays.abs(), tagDay);
      }));
    }

    int nbr = widget.from.difference(widget.to).inDays;
    return Container(
        child: Column(children: <Widget>[
      Container(
          child: DropdownButton<String>(
              value: tagSelected,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple, fontSize: 25),
              underline: Container(
                height: 3,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  tagSelected = newValue;
                });
              },
              items: [
            DropdownMenuItem<String>(
              value: "",
              child: Text("..."),
            ),
            ...tags.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text("#" + value),
              );
            }).toList()
          ])),
      Expanded(
          child: GridView.count(crossAxisCount: 7, children: [
        ...List.generate(7, (i) {
          return Container(
              child: Center(
                  child: Text(
            DateUtile.Days[i][0],
            style: TextStyle(),
          )));
        }),
        ...List.generate(widget.to.weekday, (i) {
          return Container();
        }),
        ...List.generate(nbr, (index) {
          if (dateDays.containsKey(nbr - 1 - index)) {
            return Container(
              child: Icon(
                Icons.event_available,
                color: Colors.green,
                size: 24.0,
                semanticLabel: 'tag',
              ),
            );
          } else {
            return Container(
              child: Icon(
                Icons.fiber_manual_record,
                color: Colors.black,
                size: 24.0,
                semanticLabel: 'tag',
              ),
            );
          }
        }),
      ]))
    ]));
  }
}
