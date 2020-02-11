import 'package:tag_n_go/features/chatter/domain/services/date.dart';

class DateTimeServiceImpl implements DateTimeService {
  DateTime _now;
  DateTimeServiceImpl() {
    this._now = DateTime.now();
  }
  @override
  DateTime now() {
    return _now;
  }

  void setNow(DateTime dateTime) {
    this._now = dateTime;
  }
}
