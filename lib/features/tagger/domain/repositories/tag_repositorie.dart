import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';

abstract class TagRepositiorie {
  void save(Tag tag);
  Future<Tag> getById(String id);
  Future<List<Tag>> getByName(String name);
  Stream<List<Tag>> getTags();

  void removeTag(Tag tag) {}
}
