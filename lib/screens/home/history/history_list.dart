import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/screens/home/history/history_tag_item.dart';
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
    List<Tag> myTags = Provider.of<List<Tag>>(context);
    User user = Provider.of<User>(context);

    Map<int, TagDay> dateDays = Map<int, TagDay>();
    Set<String> tags = Set();
    myTags.forEach((t) => tags.add(t.name));

    if (days != null) {
      days = days.where((tagDay) => tagDay.tags.length > 0).toList();
      dateDays.addEntries(days.map((tagDay) {
        return MapEntry(
            widget.from.difference(tagDay.date).inDays.abs(), tagDay);
      }));
    }

    int nbr = widget.from.difference(widget.to).inDays;
    return days == null
        ? Container()
        : Container(
            child: Column(children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  ...List.generate(7, (i) {
                    return Flexible(
                        flex: 1,
                        child: Container(
                            height: 40,
                            child: Center(
                                child: Text(DateUtile.Days[i][0],
                                    style: TextStyle(
                                        fontFamily: "BigSnow",
                                        color: AppColors.color2,
                                        fontSize: 20)))));
                  }),
                ],
              ),
            ),
            Expanded(
                child: GridView.count(crossAxisCount: 7, children: [
              ...List.generate((widget.to.weekday % 7), (i) {
                return Container();
              }),
              ...List.generate(nbr, (index) {
                int val = nbr - 1 - index;
                bool isToday = val == 0;
                DateTime day = widget.from.subtract(Duration(days: val));
                if (dateDays.containsKey(val)) {
                  TagDay tagDay = dateDays[val];
                  bool ischecked = (tagSelected.compareTo("") == 0 ||
                      tagDay.tags.contains(tagSelected));
                  return HistoryTagItem(
                      isToday: isToday,
                      ischecked: ischecked,
                      day: day,
                      onPressed: () async {
                        if (tagSelected.isNotEmpty) {
                          if (ischecked) {
                            tagDay.tags.remove(tagSelected);
                          } else {
                            tagDay.tags.add(tagSelected);
                          }
                          dynamic result = await user.updateToday(tagDay);
                        }
                      });
                } else {
                  return HistoryTagItem(
                      isToday: isToday,
                      ischecked: false,
                      day: day,
                      onPressed: () async {
                        if (tagSelected.isNotEmpty) {
                          TagDay tagDay =
                              TagDay(date: day, tags: Set.from([tagSelected]));
                          dynamic result = await user.updateToday(tagDay);
                        }
                      });
                }
              }),
            ])),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                        value: tagSelected,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.color5,
                        ),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(
                            fontFamily: "BigSnow",
                            fontSize: 25,
                            color: AppColors.color2),
                        underline: Container(
                          height: 3,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            tagSelected = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: "",
                            child: AutoSizeText(
                              "#",
                              style: TextStyle(
                                  fontFamily: "BigSnow",
                                  fontSize: 25,
                                  color: AppColors.color2),
                              maxLines: 1,
                            ),
                          ),
                          ...tags.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: AutoSizeText(
                                "#" + value,
                                maxLines: 1,
                              ),
                            );
                          }).toList()
                        ]),
                    Text(
                      days == null
                          ? "0"
                          : days
                                  .where((tagDay) =>
                                      (tagSelected.compareTo("") == 0 ||
                                          tagDay.tags.contains(tagSelected)))
                                  .length
                                  .toString() +
                              "/" +
                              nbr.toString(),
                      style: TextStyle(
                          fontFamily: "BigSnow",
                          fontSize: 25,
                          color: AppColors.color2),
                    )
                  ],
                )),
            SizedBox(height: 10)
          ]));
  }
}
