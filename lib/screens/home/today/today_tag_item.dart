import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/resources/app_colors.dart';

class TodayTag extends StatefulWidget {
  final Tag tag;
  final Function onSelected;
  final bool isOkToday;
  final bool isToday;

  TodayTag({Key key, this.tag, this.onSelected, this.isOkToday, this.isToday})
      : super(key: key);

  @override
  _TodayTagState createState() => _TodayTagState();
}

class _TodayTagState extends State<TodayTag>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0, end: 15).animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext buildContext, Widget child) => Container(
            height: widget.isOkToday ? 35 : widget.isToday ? 60 : 35,
            padding: EdgeInsets.symmetric(
                vertical: 1, horizontal: widget.isToday ? 0 : 30),
            child: RaisedButton(
                elevation: 10,
                color: widget.isOkToday ? AppColors.color2 : Colors.white,
                shape: StadiumBorder(
                    side: BorderSide(
                  color: widget.isOkToday ? AppColors.color5 : AppColors.color3,
                  width: widget.isOkToday
                      ? 4
                      : widget.isToday ? animation.value : 4,
                )),
                onPressed: () => widget.onSelected(widget.tag),
                child: Center(
                  child: AutoSizeText(
                    "#" + widget.tag.name,
                    style: TextStyle(
                        fontFamily: "BigSnow",
                        fontSize:
                            widget.isOkToday ? 30 : widget.isToday ? 40 : 26,
                        color: widget.isOkToday
                            ? AppColors.color5
                            : AppColors.color3),
                    maxLines: 1,
                  ),
                ))));
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
