import 'package:intl/intl.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag_day.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag_value.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tag_repositorie.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tagday_repositorie.dart';
import 'package:tag_n_go/features/tagger/domain/services/date.dart';
import 'package:uuid/uuid.dart';

class Tagger {
  String user;

  DateService dateService;
  TagRepositiorie tagRepositiorie;
  TagDayRepositiorie tagDayRepositiorie;

  Uuid uuid = Uuid();

  Tagger(this.user,
      {this.tagRepositiorie, this.tagDayRepositiorie, this.dateService});

  Tag createTag(String name) {
    Tag tag = TagImpl( uuid.v1(), name, user, Set(), Set(), null);
    tagRepositiorie.save(tag);
    return tag;
  }

  Tag changeTagName(Tag tag, String name) {
    Tag updatedTag = TagImpl(
        tag.id, name, tag.creator, tag.sharedWith, tag.weekdays, tag.type);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  Tag changeTagDays(Tag tag, Set<Weekday> days) {
    Tag updatedTag =
        TagImpl(tag.id, tag.name, tag.creator, tag.sharedWith, days, tag.type);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  Tag changeTagType(Tag tag, TagCondition condition) {
    Tag updatedTag = TagImpl(
        tag.id, tag.name, tag.creator, tag.sharedWith, tag.weekdays, condition);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  Future<Tag> getTag(String id) {
    return tagRepositiorie.getById(id);
  }

  Future<List<Tag>> getTagByName(String name) {
    return tagRepositiorie.getByName(name);
  }

  Stream<List<Tag>> getTagToday() {
    return tagRepositiorie.getTags().map((tags) =>
        tags.where((tag) => tag.isToday(dateService.weekday())).toList());
  }

  TagDay createTagDay(Tag tag, TagValue value, DateTime dateTime) {
    TagDay tagDay = TagDayImpl(tag.id, dateTime, value, user);
    tagDayRepositiorie.save(tagDay);
    return tagDay;
  }

  Stream<List<TagDay>> getTagDay({DateTime from, DateTime to}) {
    return tagDayRepositiorie.getTagDay(from: from, to: to);
  }

  removeTagDay(Tag tag, DateTime dateTime) {
    TagDay tagDay = TagDayImpl(tag.id, dateTime, null, user);
    tagDayRepositiorie.remove(tagDay);
    return tagDay;
  }

  Tag disabledTag(Tag tag) {
    Tag updatedTag = TagImpl(
        tag.id, tag.name, tag.creator, tag.sharedWith, tag.weekdays, tag.type,
        status: Status.Disabled);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  Tag activatedTag(Tag tag) {
    Tag updatedTag = TagImpl(
        tag.id, tag.name, tag.creator, tag.sharedWith, tag.weekdays, tag.type,
        status: Status.Activated);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  Tag archivedTag(Tag tag) {
    Tag updatedTag = TagImpl(
        tag.id, tag.name, tag.creator, tag.sharedWith, tag.weekdays, tag.type,
        status: Status.Archived);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }

  void removeTag(Tag tag) {
    tagRepositiorie.removeTag(tag);
  }

  Tag changeShareWith(Tag tag, Set<String> sharedWith) {
    Tag updatedTag = TagImpl(
        tag.id, tag.name, tag.creator, sharedWith, tag.weekdays, tag.type,
        status: tag.status);
    tagRepositiorie.save(updatedTag);
    return updatedTag;
  }
}
