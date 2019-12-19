import 'package:intl/intl.dart';

class DateUtile {
  static final List<String> Days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static DateTime now() {
    DateTime now = DateTime.now();
    return now.subtract(Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        microseconds: now.microsecond,
        milliseconds: now.millisecond));
  }
}
