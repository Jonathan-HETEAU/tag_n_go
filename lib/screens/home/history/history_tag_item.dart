import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:tag_n_go/resources/app_colors.dart';

class HistoryTagItem extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool ischecked;
  final Function onPressed;

  HistoryTagItem({this.day, this.isToday, this.ischecked, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onDoubleTap: onPressed,
      child: Container(
        child: Center(
            child: Column(children: [
          AutoSizeText(
            DateFormat("yyyy/MM").format(day),
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: 1,
          ),
          Text(DateFormat("dd").format(day),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              )),
        ])),
        decoration: BoxDecoration(
          color: ischecked ? Colors.black : Colors.white.withAlpha(50),
          border: Border.all(
            color: isToday
                ? Colors.white
                : AppColors.color5, //                   <--- border color
            width: isToday ? 5.0 : 1.0,
          ),
        ),
      ),
    );
  }
}
