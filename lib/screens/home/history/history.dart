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
  DateTime _to = DateUtile.now().subtract(Duration(days: 28));
  GlobalKey _keyForm = GlobalKey<FormState>();
  double _semaine = 4;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return user == null
        ? Container()
        : StreamProvider<List<TagDay>>.value(
            value: user.history(from: _from, to: _to),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                      "History :  " + _semaine.toInt().toString() + " week(s)"),
                  actions: <Widget>[],
                ),
                body: Column(children: <Widget>[
                  Form(
                      key: _keyForm,
                      child: Slider(
                        max: 54,
                        min: 1,
                        divisions: 53,
                        value: _semaine,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            _semaine = value;
                            _to = DateUtile.now().subtract(
                                Duration(days: (7 * _semaine).toInt()));
                          });
                        },
                      )),
                  Expanded(
                      child: HistoryList(
                    from: _from,
                    to: _to,
                  )),
                ])));
  }
}
