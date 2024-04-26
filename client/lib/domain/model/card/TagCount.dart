import 'Tag.dart';

class TagCount {
  final Tag tag;
  final int count;

  TagCount({
    required this.tag,
    required this.count,
  });
  factory TagCount.fromJson(Map<String, dynamic> e) {
    return TagCount(
      tag: Tag.fromString(e['tag'] as String),
      count: e['count'] as int,
    );
  }
}
