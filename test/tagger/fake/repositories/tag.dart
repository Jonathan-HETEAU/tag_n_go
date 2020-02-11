import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tag_repositorie.dart';

class TagRepositorieImpl implements TagRepositiorie {
  TagRepositorieImpl(String user, Map<String, Tag> depot) {
    this.user = user;
    this.depot = depot;
  }
  String user;
  Map<String, Tag> depot;
  StreamController<List<Tag>> controller;

  @override
  Future<Tag> getById(String id) {
    return depot.containsKey(id)
        ? Future.value(depot[id])
        : Future.error("Pas de Tag avec cet id");
  }

  @override
  void save(Tag tag) {
    depot.addEntries([MapEntry(tag.id, tag)]);
    if (controller != null) {
      controller.add(depot.values.toList());
    }
  }

  @override
  Future<List<Tag>> getByName(String name) {
    return Future.value(depot.entries
        .where((entry) => entry.value.name.compareTo(name) == 0)
        .map((entry) => entry.value)
        .toList());
  }

  @override
  Stream<List<Tag>> getTags() {
    if (controller == null) {
      controller = StreamController<List<Tag>>();
      controller.add(depot.values.toList());
    }
    return controller.stream.asBroadcastStream();
  }

  @override
  void removeTag(Tag tag) {
    depot.remove(tag.id);
  }
}
