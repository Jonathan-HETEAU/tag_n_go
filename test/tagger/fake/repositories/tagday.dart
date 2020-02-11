import 'dart:async';

import 'package:intl/intl.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag_day.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tagday_repositorie.dart';

class TagDayStreamController {
  DateTime _from;
  DateTime _to;

  StreamController<List<TagDay>> _controller = StreamController<List<TagDay>>();

  TagDayStreamController(this._from, this._to);

  Stream<List<TagDay>> get stream {
    return this._controller.stream.asBroadcastStream();
  }

  add(List<TagDay> tagDays) {
    this._controller.add(tagDays
        .where((tagday) => tagday.date.compareTo(this._from) >= 0)
        .where((tagday) => tagday.date.isBefore(this._to))
        .toList());
  }
}

class TagDayRepositiorieImpl implements TagDayRepositiorie {
  Map<String, TagDay> tagDays = Map<String, TagDay>();
  List<TagDayStreamController> controllers = List<TagDayStreamController>();
  DateFormat formatter = DateFormat('yyyyMMdd');
  String user;

  TagDayRepositiorieImpl(this.user, this.tagDays);

  @override
  void save(TagDay tagDay) {
    tagDays.addEntries(
        [MapEntry("${tagDay.tag}-${formatter.format(tagDay.date)}", tagDay)]);
    controllers
        .forEach((controller) => controller.add(tagDays.values.toList()));
  }

  @override
  Stream<List<TagDay>> getTagDay({DateTime from, DateTime to}) {
    TagDayStreamController controller = TagDayStreamController(from, to);
    controllers.add(controller);
    controller.add(tagDays.values.toList());

    return controller.stream;
  }

  @override
  void remove(TagDay tagDay) {
    tagDays.remove("${tagDay.tag}-${formatter.format(tagDay.date)}");
    controllers
        .forEach((controller) => controller.add(tagDays.values.toList()));
  }
}
