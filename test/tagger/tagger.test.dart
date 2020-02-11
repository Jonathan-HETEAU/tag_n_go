import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag_day.dart';
import 'package:tag_n_go/features/tagger/domain/entities/tag_value.dart';
import 'package:tag_n_go/features/tagger/domain/services/date.dart';
import 'package:tag_n_go/features/tagger/domain/usecases/tagger.dart';

import 'fake/repositories/tag.dart';
import 'fake/repositories/tagday.dart';
import 'fake/services/date.dart';

void main() {
  group("Tagger ", () {
    group("Tag", () {
      test("Crée une  tache journaliére", () async {
        Tagger tagger = Tagger("user",
            tagRepositiorie: TagRepositorieImpl("user", Map()),
            dateService: DateServiceImpl());
        Tag tag1 = tagger.createTag("TagName");

        Tag tag2 = await Future.delayed(Duration(seconds: 0), () {
          return Future.value(tagger.createTag("TagName"));
        });

        expect(tag1.compareTo(tag2) == 0, isFalse);
        var tags = await tagger.getTagByName("TagName");
        expect(tags.length, equals(2));
      });
      test("Change Name", () async {
        Tagger tagger = Tagger("user",
            tagRepositiorie: TagRepositorieImpl("user", Map()),
            dateService: DateServiceImpl());
        Tag tag = tagger.createTag("name");
        Tag newTag = tagger.changeTagName(tag, "newName");
        expect(tag.compareTo(newTag) == 0, isTrue);
        expect(tag.name.compareTo(newTag.name) == 0, isFalse);
        Tag getTag = await tagger.getTag(tag.id);
        expect(newTag.name.compareTo(getTag.name) == 0, isTrue);
      });
      group("Today", () {
        test("Today par jour de la semaine", () async {
          Tagger tagger = Tagger("user",
              tagRepositiorie: TagRepositorieImpl("user", Map()),
              dateService: DateServiceImpl(day: Weekday.Monday));

          Tag today1 = tagger.createTag("tag1");
          today1 = tagger.changeTagDays(today1, Set.from([Weekday.Monday]));
          Tag today2 = tagger.createTag("tag2");
          today2 = tagger.changeTagDays(today2, Set.from([Weekday.Monday]));
          Tag notToday = tagger.createTag("tag3");
          notToday = tagger.changeTagDays(notToday, Set.from([Weekday.Friday]));
          Tag notToday2 = tagger.createTag("tag4");
          notToday2 =
              tagger.changeTagDays(notToday2, Set.from([Weekday.Monday]));
          notToday2 = tagger.disabledTag(notToday2);
          List<Tag> tags = await streamListener(tagger.getTagToday());
          expect(tags.length, equals(2));
        });
        test("Valide Tag", () async {
          Tagger tagger = Tagger("user",
              tagRepositiorie: TagRepositorieImpl("user", Map()),
              dateService: DateServiceImpl(day: Weekday.Monday),
              tagDayRepositiorie: TagDayRepositiorieImpl("user", Map()));

          Tag tag = tagger.createTag("MyTag");

          tagger.createTagDay(tag, TagValue(value: true, type: tag.type),
              DateTime.parse('2020-01-04'));

          Stream<List<TagDay>> stream = tagger.getTagDay(
              from: DateTime.parse('2020-01-04'),
              to: DateTime.parse('2020-01-05'));

          List<TagDay> tagDays = await streamListener(stream);

          expect(tagDays.length, equals(1));
          expect(tagDays.last.isValidated(), isTrue);

          tagger.createTagDay(tag, TagValue(value: false, type: tag.type),
              DateTime.parse('2020-01-04'));

          tagDays = await streamListener(stream);

          expect(tagDays.length, equals(1));
          expect(tagDays.last.isValidated(), isFalse);

          tagger.removeTagDay(tag, DateTime.parse('2020-01-04'));

          tagDays = await streamListener(stream);
          expect(tagDays.length, equals(0));
        });
        test("Change Type de tag", () {
          Tagger tagger = Tagger("user",
              tagRepositiorie: TagRepositorieImpl("user", Map()),
              dateService: DateServiceImpl(),
              tagDayRepositiorie: TagDayRepositiorieImpl("user", Map()));
          Tag tag = tagger.createTag("tag");
          expect(tag.type.type, equals(TagConditionType.Check));
          tag = tagger.changeTagType(tag, Counter(minimumValide: 10));
          expect(tag.type.type, equals(TagConditionType.Counter));
          tag = tagger.changeTagType(tag, Measure(base: 10, unit: "kg"));
          expect(tag.type.type, equals(TagConditionType.Measure));
        });
        group("TagValue", () {
          test("Boolean", () {
            expect(TagValue(value: 2, type: Check()).isValid(), isFalse);
            expect(TagValue(value: "aojoj", type: Check()).isValid(), isFalse);
            expect(TagValue(value: 2.00, type: Check()).isValid(), isFalse);
            expect(TagValue(value: 3, type: Check()).isValid(), isFalse);
            expect(TagValue(value: false, type: Check()).isValid(), isFalse);
            expect(TagValue(value: true, type: Check()).isValid(), isTrue);
          });
          test("Compteur", () {
            expect(
                TagValue(value: 2, type: Counter(minimumValide: 3)).isValid(),
                isFalse);
            expect(
                TagValue(value: true, type: Counter(minimumValide: 3))
                    .isValid(),
                isFalse);
            expect(
                TagValue(value: "aojojojojoj", type: Counter(minimumValide: 3))
                    .isValid(),
                isFalse);
            expect(
                TagValue(value: 3.00, type: Counter(minimumValide: 3))
                    .isValid(),
                isFalse);
            expect(
                TagValue(value: 3, type: Counter(minimumValide: 3)).isValid(),
                isTrue);
          });
          test("Value + unit", () {
            TagValue tagValue =
                TagValue(value: 105.2, type: Measure(unit: "kg", base: 10));
            expect(tagValue.isValid(), isTrue);
          });
        });
      });
      test("Un tag peut étre actif/inactif", () {
        Tagger tagger = Tagger("user",
            tagRepositiorie: TagRepositorieImpl("user", Map()),
            dateService: DateServiceImpl(day: Weekday.Monday),
            tagDayRepositiorie: TagDayRepositiorieImpl("user", Map()));

        Tag tag = tagger.createTag("tag");
        expect(tag.activated, isTrue);
        tag = tagger.disabledTag(tag);
        expect(tag.activated, isFalse);
        tag = tagger.activatedTag(tag);
        expect(tag.activated, isTrue);
      });
      test("Un tag peut étre archiver", () {
        Tagger tagger = Tagger("user",
            tagRepositiorie: TagRepositorieImpl("user", Map()),
            dateService: DateServiceImpl(day: Weekday.Monday),
            tagDayRepositiorie: TagDayRepositiorieImpl("user", Map()));

        Tag tag = tagger.createTag("tag");
        expect(tag.status, equals(Status.Activated));
        tag = tagger.archivedTag(tag);
        expect(tag.status, equals(Status.Archived));
      });
      test("Un tag peut étre supprimer", () async {
        Tagger tagger = Tagger("user",
            tagRepositiorie: TagRepositorieImpl("user", Map()),
            dateService: DateServiceImpl());
        Tag tag = tagger.createTag("TagName");
        var tags = await tagger.getTagByName("TagName");

        expect(tags.length, equals(1));
        tagger.removeTag(tag);
        tags = await tagger.getTagByName("TagName");
        expect(tags.length, equals(0));
      });
      group("Partage", () {
        test("Un tag peut étre partager avec plusieur utilisateur", () async {
          DateService dateService = DateServiceImpl(day: Weekday.Monday);
          Map<String, Tag> depot = Map<String, Tag>();
          Map<String, TagDay> tagDaysDepot = Map<String, TagDay>();
          var user = "User2";
          var creator = "User1";
          Tagger tagger1 = Tagger(creator,
              tagRepositiorie: TagRepositorieImpl(creator, depot),
              tagDayRepositiorie: TagDayRepositiorieImpl(creator, tagDaysDepot),
              dateService: dateService);
          Tagger tagger2 = Tagger(user,
              tagRepositiorie: TagRepositorieImpl(user, depot),
              tagDayRepositiorie: TagDayRepositiorieImpl(user, tagDaysDepot),
              dateService: dateService);

          Tag tag = tagger1.createTag("Tag1");
          tag = tagger1.changeTagDays(tag, Set.from([Weekday.Monday]));
          tag = tagger1.changeShareWith(tag, Set.from([user]));

          Stream<List<Tag>> stream2 = tagger2.getTagToday();
          List<Tag> tags = await streamListener(stream2);

          expect(tags.length, equals(1));
          expect(tags.last.creator, equals(creator));
          expect(tags.last.sharedWith, contains(user));

          tagger2.createTagDay(tag, TagValue(type: tag.type, value: true),
              DateTime.parse('2020-01-04 00:08'));

          Stream<List<TagDay>> stream = tagger1.getTagDay(
              from: DateTime.parse('2020-01-04'),
              to: DateTime.parse('2020-01-05'));

          List<TagDay> tagDays = await streamListener(stream);
          expect(tagDays.length, equals(1));
          expect(tagDays.last.validator, equals(user));
        });
      });
    });
  });
}

Function streamListener = (stream) async {
  await for (var value in stream) {
    return value;
  }
};
