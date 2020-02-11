import 'package:tag_n_go/features/tagger/domain/entities/tag_value.dart';

abstract class TagDay implements Comparable<TagDay> {
  String get tag;
  String get validator;
  DateTime get date;
  bool isValidated();
}

class TagDayImpl implements TagDay {
  String tag;
  DateTime date;
  TagValue value;
  String validator;

  TagDayImpl(this.tag, this.date, this.value, this.validator);

  @override
  bool isValidated() => value.isValid();

  @override
  int compareTo(TagDay other) {
    int result = tag.compareTo(other.tag);
    if (result != 0) {
      result = date.compareTo(other.date);
    }
    return result;
  }
}
