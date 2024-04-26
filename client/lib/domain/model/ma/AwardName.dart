import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';

enum AwardName implements MilestoneAwardName {
  // Tharsis
  LANDLORD,
  SCIENTIST,
  BANKER,
  THERMALIST,
  MINER,

  // Elysium
  CELEBRITY,
  INDUSTRIALIST,
  DESERT_SETTLER,
  ESTATE_DEALER,
  BENEFACTOR,

  // Hellas
  CONTRACTOR,
  CULTIVATOR,
  EXCENTRIC,
  MAGNATE,
  SPACE_BARON,

  // Venus
  VENUPHILE,

  // Ares
  ENTREPRENEUR,

  // The Moon
  FULL_MOON,
  LUNAR_MAGNATE,

  // Amazonis Planitia
  CURATOR,
  ENGINEER,
  HISTORIAN,
  TOURIST,
  A_ZOOLOGIST,

  // Arabia Terra
  COSMIC_SETTLER,
  BOTANIST,
  COORDINATOR,
  MANUFACTURER,
  ZOOLOGIST,

  // Terra Cimmeria
  BIOLOGIST,
  T_ECONOMIZER,
  POLITICIAN,
  URBANIST,
  WARMONGER,

  // Vastitas Borealis
  ADAPTER,
  EDGEDANCER,
  HOARDER,
  NATURALIST,
  VOYAGER,

  // Underworld
  KINGPIN,
  EDGELORD;

  static const _TO_STRING_MAP = {
    LANDLORD: 'Landlord',
    SCIENTIST: 'Scientist',
    BANKER: 'Banker',
    THERMALIST: 'Thermalist',
    MINER: 'Miner',

    // Elysium
    CELEBRITY: 'Celebrity',
    INDUSTRIALIST: 'Industrialist',
    DESERT_SETTLER: 'Desert Settler',
    ESTATE_DEALER: 'Estate Dealer',
    BENEFACTOR: 'Benefactor',

    // Hellas
    CONTRACTOR: 'Contractor',
    CULTIVATOR: 'Cultivator',
    EXCENTRIC: 'Excentric',
    MAGNATE: 'Magnate',
    SPACE_BARON: 'Space Baron',

    // Venus
    VENUPHILE: 'Venuphile',

    // Ares
    ENTREPRENEUR: 'Entrepreneur',

    // The Moon
    FULL_MOON: 'Full Moon',
    LUNAR_MAGNATE: 'Lunar Magnate',

    // Amazonis Planitia
    CURATOR: 'Curator',
    ENGINEER: 'Engineer',
    HISTORIAN: 'Historian',
    TOURIST: 'Tourist',
    A_ZOOLOGIST: 'A. Zoologist',

    // Arabia Terra
    COSMIC_SETTLER: 'Cosmic Settler',
    BOTANIST: 'Botanist',
    COORDINATOR: 'Coordinator',
    MANUFACTURER: 'Manufacturer',
    ZOOLOGIST: 'Zoologist',

    // Terra Cimmeria
    BIOLOGIST: 'Biologist',
    T_ECONOMIZER: 'T. Economizer',
    POLITICIAN: 'Politician',
    URBANIST: 'Urbanist',
    WARMONGER: 'Warmonger',

    // Vastitas Borealis
    ADAPTER: 'Adapter',
    EDGEDANCER: 'Edgedancer',
    HOARDER: 'Hoarder',
    NATURALIST: 'Naturalist',
    VOYAGER: 'Voyager',
    // Underworld
    KINGPIN: 'Kingpin',
    EDGELORD: 'EdgeLord',
  };
  static final _TO_IMAGE_PATH_MAP = {
    LANDLORD: Assets.ma.landlord.path,
    SCIENTIST: Assets.ma.scientist.path,
    BANKER: Assets.ma.banker.path,
    THERMALIST: Assets.ma.thermalist.path,
    MINER: Assets.ma.miner.path,

    // Elysium
    CELEBRITY: Assets.ma.celebrity.path,
    INDUSTRIALIST: Assets.ma.industrialist.path,
    DESERT_SETTLER: Assets.ma.desertSettler.path,
    ESTATE_DEALER: Assets.ma.estateDealer.path,
    BENEFACTOR: Assets.ma.benefactor.path,

    // Hellas
    CONTRACTOR: Assets.ma.contractor.path,
    CULTIVATOR: Assets.ma.cultivator.path,
    EXCENTRIC: Assets.ma.excentric.path,
    MAGNATE: Assets.ma.magnate.path,
    SPACE_BARON: Assets.ma.spaceBaron.path,

    // Venus
    VENUPHILE: Assets.ma.venuphile.path,

    // Ares
    ENTREPRENEUR: Assets.ma.entrepreneur.path,

    // The Moon
    FULL_MOON: Assets.ma.fullMoon.path,
    LUNAR_MAGNATE: Assets.ma.lunarMagnate.path,

    // Amazonis Planitia
    CURATOR: Assets.ma.fanmade.curator.path,
    ENGINEER: Assets.ma.fanmade.engineer.path,
    HISTORIAN: Assets.ma.fanmade.historian.path,
    TOURIST: Assets.ma.fanmade.tourist.path,
    A_ZOOLOGIST: Assets.ma.fanmade.zoologist.path,

    // Arabia Terra
    COSMIC_SETTLER: Assets.ma.cosmicSettler.path,
    BOTANIST: Assets.ma.botanist.path,
    COORDINATOR: Assets.ma.coordinator.path,
    MANUFACTURER: Assets.ma.manufacturer.path,
    ZOOLOGIST: Assets.ma.zoologist.path,

    // Terra Cimmeria
    BIOLOGIST: Assets.ma.fanmade.biologist.path,
    T_ECONOMIZER: Assets.ma.fanmade.economizer.path,
    POLITICIAN: Assets.ma.fanmade.politician.path,
    URBANIST: Assets.ma.fanmade.urbanist.path,
    WARMONGER: Assets.ma.fanmade.warmonger.path,

    // Vastitas Borealis
    ADAPTER: Assets.ma.adapter.path,
    EDGEDANCER: Assets.ma.edgedancer.path,
    HOARDER: Assets.ma.hoarder.path,
    NATURALIST: Assets.ma.naturalist.path,
    VOYAGER: Assets.ma.voyager.path,

    // Underworld
    KINGPIN: Assets.ma.underworld.kingpin.path,
    EDGELORD: Assets.ma.underworld.edgelord.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  @override
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
