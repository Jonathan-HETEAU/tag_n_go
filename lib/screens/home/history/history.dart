import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/screens/home/history/history_list.dart';
import 'package:tag_n_go/shared/date.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime _from = DateUtile.now();
  DateTime _to = DateUtile.now().subtract(Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return user == null
        ? Container()
        : StreamProvider<List<TagDay>>.value(
            value: user.history(from: _from, to: _to),
            child: Scaffold(
              appBar: AppBar(
                title: Text("History"),
                actions: <Widget>[],
              ),
              body: HistoryList(
                from: _from,
                to: _to,
              ),
            ));
  }
}
