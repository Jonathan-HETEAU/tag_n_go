import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';
import 'package:tag_n_go/features/tagger/domain/services/date.dart';

class DateServiceImpl implements DateService {
  Weekday day = Weekday.Monday;
  DateServiceImpl({this.day});

  @override
  Weekday weekday() {
    return day;
  }

  @override
  String nowToString() {
    return "${DateTime.now().millisecondsSinceEpoch}";
  }
}
