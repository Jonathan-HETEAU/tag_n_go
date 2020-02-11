import 'package:tag_n_go/features/profiler/domain/entities/profil.dart';

abstract class PepMessage implements Comparable<PepMessage> {
  String get hashtag;
  String get message;
  Profil get author;
  DateTime get created;
}

class PepMessageImpl implements PepMessage {
  String hashtag;
  String message;
  Profil author;
  DateTime created;

  PepMessageImpl(this.author, this.hashtag, this.message, this.created);

  @override
  int compareTo(PepMessage other) {
    int result = author.compareTo(other.author);
    if (result == 0) {
      result = hashtag.compareTo(other.hashtag);
      if (result == 0) {
        if (_dateWithoutTimeIsEqual(created, other.created)) {
          result = 0;
        } else {
          result = created.compareTo(other.created);
        }
      }
    }
    return result;
  }

  bool _dateWithoutTimeIsEqual(DateTime created, DateTime created2) {
    return created.day == created2.day &&
        created.month == created2.month &&
        created.year == created2.year;
  }
}
