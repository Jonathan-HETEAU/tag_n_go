class TagValue {
  TagCondition _type;
  dynamic _value;

  TagValue({dynamic value, TagCondition type}) {
    this._type = type;
    this._value = _type.isValidTypeValue(value) ? value : type.defaultValue;
  }

  set value(value) {
    this._value = _type.isValidTypeValue(value) ? value : _value;
  }

  get value => _value;

  bool isValid() {
    return _type.isValidCondition(_value);
  }
}

enum TagConditionType { Check, Counter, Measure }
T cast<T>(x) => x is T ? x : null;

abstract class TagCondition {
  dynamic get defaultValue;
  TagConditionType get type;
  bool isValidTypeValue(dynamic value);
  bool isValidCondition(dynamic value);
  Map<String, dynamic> toJson();
}

class Check implements TagCondition {
  @override
  bool get defaultValue => false;

  @override
  bool isValidCondition(value) {
    return isValidTypeValue(value) && _assessConditions(cast<bool>(value));
  }

  bool _assessConditions(bool value) {
    return value;
  }

  @override
  bool isValidTypeValue(value) {
    return value is bool;
  }

  @override
  Map<String, dynamic> toJson() => {'type': this.type};

  @override
  TagConditionType get type => TagConditionType.Check;
}

class Counter implements TagCondition {
  int minimumValide;
  Counter({this.minimumValide = 1});

  @override
  int get defaultValue => 0;

  @override
  bool isValidCondition(value) =>
      isValidTypeValue(value) && _assessConditions(cast<int>(value));

  bool _assessConditions(int value) => value >= minimumValide;

  @override
  bool isValidTypeValue(value) => value is int;

  @override
  Map<String, dynamic> toJson() =>
      {'type': this.type, 'minimumValide': this.minimumValide};

  @override
  TagConditionType get type => TagConditionType.Counter;
}

class Measure implements TagCondition {
  int _base;
  String _unit;

  Measure({String unit = "", int base = 10}){
    this._unit = unit;
    this._base = base;
  }

  @override
  num get defaultValue => 0.00;

  @override
  bool isValidCondition(value) =>
      isValidTypeValue(value) && _assessConditions(cast<num>(value));

  bool _assessConditions(num value) => value.compareTo(defaultValue) != 0;

  @override
  bool isValidTypeValue(value) => value is num;

  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'unit': _unit, 'base': _base};

  @override
  TagConditionType get type => TagConditionType.Measure;

  String get unit => _unit;
  int get base => _base;

}
