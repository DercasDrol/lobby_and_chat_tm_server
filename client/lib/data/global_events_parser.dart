import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/ClientGlobalEvent.dart';

class GlobalEventsParser {
  static parse() async {
    getData() {
      if (kIsWeb) {
        return rootBundle.loadString(Assets.jsons.events);
      } else {
        final File file = File(Assets.jsons.events);
        return file.readAsString();
      }
    }

    final data = await getData();
    final decodedJson = jsonDecode(data);
    ClientGlobalEvent.setAllEvents(
      decodedJson
          .map((json) => ClientGlobalEvent.fromJson(json))
          .cast<ClientGlobalEvent>()
          .toList(),
    );
  }
}
