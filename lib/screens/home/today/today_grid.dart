import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/screens/home/today/today_tag_item.dart';

class TodayGrid extends StatelessWidget {
  final Function onSelected;

  TodayGrid({this.onSelected});

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<List<Tag>>(context);
    TagDay tagsToday = Provider.of<TagDay>(context);
    int day = DateTime.now().weekday - 1;
    if (tags != null && tagsToday != null) {
      tags.sort((tag1, tag2) {
        if (tagsToday.tags.contains(tag1.name)) {
          return 1;
        } else {
          if (tagsToday.tags.contains(tag1.name)) {
            return -1;
          } else {
            return tag1.name.compareTo(tag2.name);
          }
        }
      });
    }
    return tags == null || tagsToday == null
        ? Container()
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  AppColors.color5,
                  AppColors.color4,
                  AppColors.color2
                ])),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListView(
                  children: tags.map((tag) {
                    bool isOkToday = tagsToday.tags.contains(tag.name);
                    return TodayTag(
                        isOkToday: isOkToday,
                        onSelected: onSelected,
                        tag: tag,
                        isToday: tag.activated && tag.days[day]);
                  }).toList(),
                )));
  }
}
