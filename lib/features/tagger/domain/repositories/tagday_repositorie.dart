import 'package:tag_n_go/features/tagger/domain/entities/tag_day.dart';

abstract class TagDayRepositiorie {
  void save(TagDay tagDay);
  void remove(TagDay tagDay);

  Stream<List<TagDay>> getTagDay({DateTime from, DateTime to});
}
