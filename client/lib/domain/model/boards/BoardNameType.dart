import 'dart:ui';

import 'package:mars_flutter/domain/model/boards/BoardName.dart';
import 'package:mars_flutter/domain/model/boards/RandomBoardOption.dart';

abstract class BoardNameType {
  String? get descriptionUrl;
  String get name;
  Color get color;
  String get shortName;
  static fromString(String e) {
    if (BoardName.fromString(e) != null) {
      return BoardName.fromString(e);
    } else {
      return RandomBoardOption.fromString(e);
    }
  }
}
