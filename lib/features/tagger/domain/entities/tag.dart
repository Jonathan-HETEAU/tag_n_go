import 'package:tag_n_go/features/tagger/domain/entities/tag_value.dart';

enum Weekday { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
enum Status { Activated, Disabled, Archived }

abstract class Tag implements Comparable<Tag> {
  String get id;
  String get name;
  Status get status;
  String get creator;
  bool get activated;
  TagCondition get type;
  Set<String> get sharedWith;
  Set<Weekday> get weekdays;
  bool isToday(Weekday weekday);
  bool isInitiatedBy(String user);
}

class TagImpl implements Tag {
  String _id;
  String _name;
  Status _status;
  TagCondition _type;
  Set<Weekday> _weekdays;
  String _creator;
  Set<String> _sharedWith;

  TagImpl(String id, String name, String creator, Set<String> sharedWith,
      Set<Weekday> weekdays, TagCondition tagCondition,
      {Status status = Status.Activated}) {
    this._id = id;
    this._name = name;
    this._weekdays = Set.from(weekdays);
    this._type = tagCondition == null ? Check() : tagCondition;
    this._status = status;
    this._sharedWith = sharedWith;
    this._creator = creator;
  }

  bool equalTo(Tag other) {
    return compareTo(other) == 0;
  }

  @override
  int compareTo(Tag other) {
    return this.id.compareTo(other.id);
  }

  @override
  String get id => _id;

  @override
  String get name => _name;

  set name(String name) => _name = name;

  @override
  Set<Weekday> get weekdays => Set.from(_weekdays);

  @override
  bool isToday(Weekday day) {
    return activated && _weekdays.contains(day);
  }

  @override
  TagCondition get type => _type;

  @override
  bool get activated => Status.Activated == _status;

  @override
  Status get status => _status;

  @override
  String get creator => _creator;

  @override
  Set<String> get sharedWith => _sharedWith;

  @override
  bool isInitiatedBy(String user) {
    return this._creator.compareTo(user) == 0;
  }
}
