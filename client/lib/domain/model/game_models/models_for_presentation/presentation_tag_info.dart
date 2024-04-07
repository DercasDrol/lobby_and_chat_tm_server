import 'package:mars_flutter/domain/model/card/Tag.dart';

class TagInfo {
  final Tag tag;
  final int count;
  final int discont;

  TagInfo({
    required this.tag,
    required this.count,
    required this.discont,
  });
}
