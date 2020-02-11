import 'package:tag_n_go/features/profiler/domain/service/date.dart';

class DateServiceImpl implements DateService {
  DateTime now;
  DateTime today;

  DateServiceImpl(this.now, this.today);
}
