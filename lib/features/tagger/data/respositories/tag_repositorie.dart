import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tag_repositorie.dart';

class TagRepositiorieFirebaseImpl implements TagRepositiorie {
  CollectionReference tagCollection;

  @override
  Future<Tag> getById(String id) {}

  @override
  Future<List<Tag>> getByName(String name) {}

  @override
  Stream<List<Tag>> getTags() {}

  @override
  void removeTag(Tag tag) {}

  @override
  void save(Tag tag) {}
}
