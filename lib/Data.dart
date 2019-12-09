class Data {
  Map<String, TagType> tags = new Map();
}

class TagType {
  List<bool> days = new List(7);
  bool activated;
  Set<DateTime> history = new Set();
}
