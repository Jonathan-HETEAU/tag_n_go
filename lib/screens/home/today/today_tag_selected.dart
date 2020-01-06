import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/resources/app_colors.dart';
import 'package:tag_n_go/shared/loading.dart';

class ModalTag extends StatelessWidget {
  final Tag tag;
  final Function onClose;
  final Function onChange;
  ModalTag({this.tag, this.onClose, this.onChange});

  @override
  Widget build(BuildContext context) {
    TagDay tagsToday = Provider.of<TagDay>(context);
    bool isActif = tagsToday.tags.contains(tag.name);
    return tagsToday == null
        ? Loading()
        : Hero(
            tag: "tag",
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                    child: RaisedButton(
                        onPressed: onClose,
                        color: AppColors.color2.withAlpha(200))),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 150.0,
                    horizontal: 50.0,
                  ),
                  child: Card(
                      shape: StadiumBorder(
                          side: BorderSide(
                        color: isActif ? AppColors.color5 : AppColors.color3,
                        width: 10,
                      )),
                      elevation: 15,
                      color: isActif ? Colors.black : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Switch(
                            activeColor: AppColors.color5,
                            inactiveThumbColor: AppColors.color3,
                            value: isActif,
                            onChanged: (bool status) {
                              if (status) {
                                tagsToday.tags.add(tag.name);
                              } else {
                                tagsToday.tags.remove(tag.name);
                              }
                              onChange(tagsToday);
                            },
                          )
                        ],
                      )),
                ),
                Align(
                    alignment: Alignment(0, -0.2),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.0,
                      ),
                      child: AutoSizeText(
                        "#" + tag.name,
                        style: TextStyle(
                            color: isActif ? Colors.white : Colors.black,
                            fontFamily: "BigSnow",
                            fontSize: 50),
                        maxLines: 1,
                      ),
                    ))
              ],
            ));
  }
}
