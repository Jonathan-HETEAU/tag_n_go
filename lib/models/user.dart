import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tag_n_go/models/day.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/screens/home/history/history.dart';
import 'package:tag_n_go/shared/date.dart';

class User {
  final String uid;
  final CollectionReference tagsCollection;
  final CollectionReference historyCollection;

  User({this.uid, this.tagsCollection, this.historyCollection});

  Future updateTag(Tag tag) async {
    try {
      return await tagsCollection
          .document(tag.name)
          .setData({'activated': tag.activated, 'days': tag.days});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteTag(Tag tag) async {
    try {
      return await tagsCollection.document(tag.name).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateToday(TagDay tagsToday) async {
    String stringDate = DateFormat("yyyyMMdd").format(tagsToday.date);
    try {
      return await historyCollection.document(stringDate).setData({
        'tags': tagsToday.tags.toList(),
        'date': Timestamp.fromDate(tagsToday.date)
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<Tag> _tagListFromSnapShot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return Tag(
          name: doc.documentID,
          activated: doc.data['activated'] ?? false,
          days: List<bool>.from(doc.data['days'] ??
              [false, false, false, false, false, false, false]));
    }).toList();
  }

  Stream<List<Tag>> get tags {
    return tagsCollection.snapshots().map(_tagListFromSnapShot);
  }

  TagDay _tagsSetFromSnapShot(DocumentSnapshot doc) {
    return TagDay(
        date: doc.data != null
            ? (doc.data['date'] as Timestamp).toDate() ?? DateUtile.now()
            : DateUtile.now(),
        tags: Set<String>.from(doc.data != null ? doc.data['tags'] ?? [] : [])
            .toSet());
  }

  Stream<TagDay> get today {
    String stringDate = DateFormat("yyyyMMdd").format(DateUtile.now());
    DocumentReference ref = historyCollection.document(stringDate);
    return ref.snapshots().map(_tagsSetFromSnapShot);
  }

  Stream<List<TagDay>> history({DateTime from, DateTime to}) {
    return historyCollection
        .orderBy("date", descending: false)
        .where("date", isGreaterThan: Timestamp.fromDate(to))
        .snapshots()
        .map((snap) {
      return snap.documents.map((doc) {
        return _tagsSetFromSnapShot(doc);
      }).toList();
    });
  }
}
