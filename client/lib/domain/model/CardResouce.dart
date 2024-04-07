import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum CardResource {
  ANIMAL,
  MICROBE,
  FIGHTER,
  SCIENCE,
  FLOATER,
  ASTEROID,
  PRESERVATION,
  CAMP,
  DISEASE,
  RESOURCE_CUBE,
  DATA,
  SYNDICATE_FLEET,
  VENUSIAN_HABITAT,
  SPECIALIZED_ROBOT,
  SEED,
  AGENDA,
  ORBITAL;

  static const _TO_STRING_MAP = {
    ANIMAL: 'Animal',
    MICROBE: 'Microbe',
    FIGHTER: 'Fighter',
    SCIENCE: 'Science',
    FLOATER: 'Floater',
    ASTEROID: 'Asteroid',
    PRESERVATION: 'Preservation',
    CAMP: 'Camp',
    DISEASE: 'Disease',
    RESOURCE_CUBE: 'Resource cube',
    DATA: 'Data',
    SYNDICATE_FLEET: 'Syndicate Fleet',
    VENUSIAN_HABITAT: 'Venusian Habitat',
    SPECIALIZED_ROBOT: 'Specialized Robot',
    SEED: 'Seed',
    AGENDA: 'Agenda',
    ORBITAL: 'Orbital',
  };

  static final _TO_IMAGE_PATH_MAP = {
    ANIMAL: Assets.resources.animal.path,
    MICROBE: Assets.resources.microbe.path,
    FIGHTER: Assets.resources.fighter.path,
    SCIENCE: Assets.resources.science.path,
    FLOATER: Assets.resources.floater.path,
    ASTEROID: Assets.resources.asteroid.path,
    PRESERVATION: Assets.resources.preservation.path,
    CAMP: Assets.resources.camp.path,
    DISEASE: Assets.resources.disease.path,
    RESOURCE_CUBE: Assets.cube.path,
    DATA: Assets.resources.data.path,
    SYNDICATE_FLEET: Assets.resources.syndicateFleet.path,
    VENUSIAN_HABITAT: Assets.resources.venusianHabitat.path,
    SPECIALIZED_ROBOT: Assets.resources.specializedRobot.path,
    SEED: Assets.resources.seed.path,
    AGENDA: Assets.resources.agenda.path,
    ORBITAL: Assets.resources.orbital.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static CardResource? fromString(String value) => _TO_ENUM_MAP[value];
}
