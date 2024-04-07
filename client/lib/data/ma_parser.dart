import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAwardMetadata.dart';

class MilestoneAwardParser {
  static parse() async {
    getData() {
      if (kIsWeb) {
        return rootBundle.loadString(Assets.jsons.ma);
      } else {
        final File file = File(Assets.jsons.ma);
        return file.readAsString();
      }
    }

    final data = await getData();
    final decodedJson = jsonDecode(data);
    MilestoneAwardMetadata.allMilestoneAwards = decodedJson
        .map((json) => MilestoneAwardMetadata.fromJson(json))
        .cast<MilestoneAwardMetadata>()
        .toList();
  }
}
