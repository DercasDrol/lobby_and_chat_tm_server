import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/TileType.dart';
import 'package:mars_flutter/presentation/game_components/common/tile_view.dart';

Widget getTiles() {
  return Wrap(
    children: TileType.values
        .map((e) => TileView(
              width: 50,
              height: 50,
              isCardTile: false,
              tileType: e,
              isAres: false,
            ))
        .toList(),
  );
}
