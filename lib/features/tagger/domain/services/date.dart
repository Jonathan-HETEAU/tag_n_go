import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';

abstract class DateService {
  Weekday weekday();
  String nowToString();

}