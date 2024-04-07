import 'Tag.dart';

class ITagCount {
  late Tag tag;
  late int count;

  ITagCount({
    required this.tag,
    required this.count,
  });
  static fromJson(Map<String, dynamic> e) {
    return ITagCount(
      tag: Tag.fromString(e['tag'] as String),
      count: e['count'] as int,
    );
  }
}
