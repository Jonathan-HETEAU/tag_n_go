import 'package:tag_n_go/features/tagger/domain/entities/tag_day.dart';
import 'package:tag_n_go/features/tagger/domain/repositories/tagday_repositorie.dart';

class TagDayRepositiorieFirebaseImpl implements TagDayRepositiorie{

    @override
  Stream<List<TagDay>> getTagDay({DateTime from, DateTime to}) {
    // TODO: implement getTagDay
    throw UnimplementedError();
  }

  @override
  void remove(TagDay tagDay) {
    // TODO: implement remove
  }

  @override
  void save(TagDay tagDay) {
    // TODO: implement save
  }


}