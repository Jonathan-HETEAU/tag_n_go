import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/resources/app_colors.dart';
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
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                      "History :  " + _semaine.toInt().toString() + " week(s)",
                      style: TextStyle(
                          fontFamily: "BigSnow",
                          fontSize: 40,
                          color: AppColors.color5)),
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
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withAlpha(200),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                          child: Form(
                              key: _keyForm,
                              child: Slider(
                                activeColor: AppColors.color2,
                                max: 54,
                                min: 1,
                                divisions: 53,
                                value: _semaine,
                                onChanged: (value) {
                                  setState(() {
                                    _semaine = value;
                                    _to = DateUtile.now().subtract(
                                        Duration(days: (7 * _semaine).toInt()));
                                  });
                                },
                              ))),
                      Expanded(
                          child: HistoryList(
                        from: _from,
                        to: _to,
                      )),
                    ]))));
  }
}
