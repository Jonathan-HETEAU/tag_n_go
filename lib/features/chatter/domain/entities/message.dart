class Message implements Comparable<Message> {
  String from;
  String to;
  String content;
  DateTime dateTime;
  Message({this.from, this.to, this.content, this.dateTime});

  @override
  int compareTo(Message other) {
    return this.dateTime.compareTo(other.dateTime);
  }
}
