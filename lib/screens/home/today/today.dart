import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/screens/home/today/today_grid.dart';
import 'package:tag_n_go/screens/home/today/today_tag_selected.dart';
import 'package:tag_n_go/shared/loading.dart';

class TodayScreens extends StatefulWidget {
  @override
  _TodayScreensState createState() => _TodayScreensState();
}

class _TodayScreensState extends State<TodayScreens> {
  Tag tagSelected = null;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return user == null
        ? Loading()
        : StreamProvider<TagDay>.value(
            value: user.today,
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text("Today", style: TextStyle(fontFamily: "BigSnow", fontSize: 40,color: AppColors.color5)),
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    TodayGrid(onSelected: (Tag tag) {
                      setState(() {
                        tagSelected = tag;
                      });
                    }),
                    ...tagSelected == null
                        ? []
                        : [
                            ModalTag(
                              tag: tagSelected,
                              onChange: (tagsToday) async {
                                dynamic result =
                                    await user.updateToday(tagsToday);
                              },
                              onClose: () {
                                setState(() {
                                  tagSelected = null;
                                });
                              },
                            )
                          ]
                  ],
                )));
  }
}
