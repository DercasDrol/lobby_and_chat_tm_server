import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class ClientCardsParser {
  static parse() async {
    getData() {
      if (kIsWeb) {
        return rootBundle.loadString(Assets.jsons.cards);
      } else {
        final File file = File(Assets.jsons.cards);
        return file.readAsString();
      }
    }

    final data = await getData();
    final decodedJson = jsonDecode(data);
    ClientCard.setAllCards(
      decodedJson
          .map((json) => ClientCard.fromJson(json))
          .cast<ClientCard>()
          .toList(),
    );
  }
}
