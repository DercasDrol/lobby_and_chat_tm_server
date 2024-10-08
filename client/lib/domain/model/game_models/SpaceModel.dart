import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/TileType.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/boards/SpaceBonus.dart';
import 'package:mars_flutter/domain/model/boards/SpaceType.dart';

enum SpaceHighlight {
  NOCTIS,
  VOCANIC;

  static const _TO_STRING_MAP = {
    NOCTIS: 'noctis',
    VOCANIC: 'vocanic',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}

class SpaceModel {
  final SpaceId id;
  final int x;
  final int y;
  final SpaceType spaceType;
  final List<SpaceBonus> bonus;
  final PlayerColor? color;
  final TileType? tileType;
  final SpaceHighlight? highlight;
  final bool? rotated; // Absent or true

  final int? gagarin; // 0 means current
  final bool? cathedral; // Absent or true
  final bool? nomads; // Absent or true
  final PlayerColor? coOwner;
  final int? undergroundResources;
  final PlayerColor? excavator;

  SpaceModel({
    required this.id,
    required this.x,
    required this.y,
    required this.spaceType,
    required this.bonus,
    this.color,
    this.tileType,
    this.highlight,
    this.rotated,
    this.gagarin,
    this.cathedral,
    this.nomads,
    this.coOwner,
    this.undergroundResources,
    this.excavator,
  });

  static SpaceModel fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: SpaceId.fromString(json['id'] as String),
      x: json['x'] as int,
      y: json['y'] as int,
      spaceType: SpaceType.fromString(json['spaceType'] as String),
      bonus: json['bonus']
          .map((e) => SpaceBonus.values[e as int])
          .cast<SpaceBonus>()
          .toList(),
      color: json['color'] == null
          ? null
          : PlayerColor.fromString(json['color'] as String),
      tileType: json['tileType'] == null
          ? null
          : TileType.values[json['tileType'] as int],
      highlight: json['highlight'] == null
          ? null
          : SpaceHighlight.fromString(json['highlight'] as String),
      rotated: json['rotated'] as bool?,
      gagarin: json['gagarin'] as int?,
      cathedral: json['cathedral'] as bool?,
      nomads: json['nomads'] as bool?,
      coOwner: json['coOwner'] == null
          ? null
          : PlayerColor.fromString(json['coOwner'] as String),
      undergroundResources: json['undergroundResources'] as int?,
      excavator: json['excavator'] == null
          ? null
          : PlayerColor.fromString(json['excavator'] as String),
    );
  }
}
