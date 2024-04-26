import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';

enum MilestoneName implements MilestoneAwardName {
  // Tharsis
  TERRAFORMER,
  MAYOR,
  GARDENER,
  PLANNER,
  BUILDER,

  // Elysium
  GENERALIST,
  SPECIALIST,
  ECOLOGIST,
  TYCOON,
  LEGEND,

  // Hellas
  DIVERSIFIER,
  TACTICIAN,
  POLAR_EXPLORER,
  ENERGIZER,
  RIM_SETTLER,

  // Venus
  HOVERLORD,

  // Ares
  NETWORKER,

  // The Moon
  ONE_GIANT_STEP,
  LUNARCHITECT,

  // Amazonis Planitia
  COLONIZER,
  FARMER,
  MINIMALIST,
  TERRAN,
  TROPICALIST,

  // Arabia Terra
  ECONOMIZER,
  PIONEER,
  LAND_SPECIALIST,
  MARTIAN,
  BUSINESSPERSON,

  // Terra Cimmeria
  COLLECTOR,
  FIRESTARTER,
  TERRA_PIONEER,
  SPACEFARER,
  GAMBLER,

  // Vastitas Borealis
  ELECTRICIAN,
  SMITH,
  TRADESMAN,
  IRRIGATOR,
  CAPITALIST,
  // Underworld
  TUNNELER,
  RISKTAKER;

  static const _TO_STRING_MAP = {
    // Tharsis
    TERRAFORMER: 'Terraformer',
    MAYOR: 'Mayor',
    GARDENER: 'Gardener',
    PLANNER: 'Planner',
    BUILDER: 'Builder',

    // Elysium
    GENERALIST: 'Generalist',
    SPECIALIST: 'Specialist',
    ECOLOGIST: 'Ecologist',
    TYCOON: 'Tycoon',
    LEGEND: 'Legend',

    // Hellas
    DIVERSIFIER: 'Diversifier',
    TACTICIAN: 'Tactician',
    POLAR_EXPLORER: 'Polar Explorer',
    ENERGIZER: 'Energizer',
    RIM_SETTLER: 'Rim Settler',

    // Venus
    HOVERLORD: 'Hoverlord',

    // Ares
    NETWORKER: 'Networker',

    // The Moon
    ONE_GIANT_STEP: 'One Giant Step',
    LUNARCHITECT: 'Lunarchitect',

    // Amazonis Planitia
    COLONIZER: 'Colonizer',
    FARMER: 'Farmer',
    MINIMALIST: 'Minimalist',
    TERRAN: 'Terran',
    TROPICALIST: 'Tropicalist',

    // Arabia Terra
    ECONOMIZER: 'Economizer',
    PIONEER: 'Pioneer',
    LAND_SPECIALIST: 'Land Specialist',
    MARTIAN: 'Martian',
    BUSINESSPERSON: 'Businessperson',

    // Terra Cimmeria
    COLLECTOR: 'Collector',
    FIRESTARTER: 'Firestarter',
    TERRA_PIONEER: 'Terra Pioneer',
    SPACEFARER: 'Spacefarer',
    GAMBLER: 'Gambler',

    // Vastitas Borealis
    ELECTRICIAN: 'Electrician',
    SMITH: 'Smith',
    TRADESMAN: 'Tradesman',
    IRRIGATOR: 'Irrigator',
    CAPITALIST: 'Capitalist',

    // Underworld
    TUNNELER: 'Tunneler',
    RISKTAKER: 'Risktaker',
  };
  static final _TO_IMAGE_PATH_MAP = {
    // Tharsis
    TERRAFORMER: Assets.ma.terraformer.path,
    MAYOR: Assets.ma.mayor.path,
    GARDENER: Assets.ma.gardener.path,
    PLANNER: Assets.ma.planner.path,
    BUILDER: Assets.ma.builder.path,

    // Elysium
    GENERALIST: Assets.ma.generalist.path,
    SPECIALIST: Assets.ma.specialist.path,
    ECOLOGIST: Assets.ma.ecologist.path,
    TYCOON: Assets.ma.tycoon.path,
    LEGEND: Assets.ma.legend.path,

    // Hellas
    DIVERSIFIER: Assets.ma.diversifier.path,
    TACTICIAN: Assets.ma.tactician.path,
    POLAR_EXPLORER: Assets.ma.polarExplorer.path,
    ENERGIZER: Assets.ma.energizer.path,
    RIM_SETTLER: Assets.ma.rimSettler.path,

    // Venus
    HOVERLORD: Assets.ma.hoverlord.path,

    // Ares
    NETWORKER: Assets.ma.networker.path,

    // The Moon
    ONE_GIANT_STEP: Assets.ma.oneGiantStep.path,
    LUNARCHITECT: Assets.ma.lunarchitect.path,

    // Amazonis Planitia
    COLONIZER: Assets.ma.fanmade.colonizer.path,
    FARMER: Assets.ma.fanmade.farmer.path,
    MINIMALIST: Assets.ma.fanmade.minimalist.path,
    TERRAN: Assets.ma.fanmade.terran.path,
    TROPICALIST: Assets.ma.fanmade.tropicalist.path,

    // Arabia Terra
    ECONOMIZER: Assets.ma.economizer.path,
    PIONEER: Assets.ma.pioneer.path,
    LAND_SPECIALIST: Assets.ma.landSpecialist.path,
    MARTIAN: Assets.ma.martian.path,
    BUSINESSPERSON: Assets.ma.businessperson.path,

    // Terra Cimmeria
    COLLECTOR: Assets.ma.fanmade.collector.path,
    FIRESTARTER: Assets.ma.fanmade.firestarter.path,
    TERRA_PIONEER: Assets.ma.fanmade.pioneer.path,
    SPACEFARER: Assets.ma.fanmade.spacefarer.path,
    GAMBLER: Assets.ma.fanmade.gambler.path,

    // Vastitas Borealis
    ELECTRICIAN: Assets.ma.electrician.path,
    SMITH: Assets.ma.smith.path,
    TRADESMAN: Assets.ma.tradesman.path,
    IRRIGATOR: Assets.ma.irrigator.path,
    CAPITALIST: Assets.ma.capitalist.path,

    // Underworld
    TUNNELER: Assets.ma.underworld.tunneler.path,
    RISKTAKER: Assets.ma.underworld.risktaker.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
