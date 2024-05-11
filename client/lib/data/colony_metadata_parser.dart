import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/colonies/IColonyMetadata.dart';

class ColonyMetadataParser {
  static parse() async {
    getData() {
      if (kIsWeb) {
        return rootBundle.loadString(Assets.jsons.colonies);
      } else {
        final File file = File(Assets.jsons.colonies);
        return file.readAsString();
      }
    }

    final data = await getData();
    final decodedJson = jsonDecode(data);
    IColonyMetadata.setAllColoniesMetadata(
      decodedJson
          .map((json) => IColonyMetadata.fromJson(json))
          .cast<IColonyMetadata>()
          .toList(),
    );
  }
}
