import 'Tag.dart';

class ITagCount {
  final Tag tag;
  final int count;

  ITagCount({
    required this.tag,
    required this.count,
  });
  factory ITagCount.fromJson(Map<String, dynamic> e) {
    return ITagCount(
      tag: Tag.fromString(e['tag'] as String),
      count: e['count'] as int,
    );
  }
}
