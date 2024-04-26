import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/TileType.dart';

class TileView extends StatelessWidget {
  const TileView({
    required this.tileType,
    required this.isAres,
    required this.isCardTile,
    required this.height,
    required this.width,
  });
  final TileType tileType;
  final double height;
  final double width;
  final bool isAres;
  final bool isCardTile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _prepareTileView(),
    );
  }

  Widget _getSpecialTile(String filePath) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Image(image: AssetImage(Assets.tiles.special.path)),
      Image(image: AssetImage(filePath))
    ]);
  }

  Widget _prepareTileView() {
    switch (tileType) {
      case TileType.GREENERY:
        return Image(
            image: AssetImage(isCardTile
                ? Assets.tiles.greenery.path
                : Assets.tiles.greeneryNoO2.path));
      case TileType.OCEAN:
        return Image(image: AssetImage(Assets.tiles.ocean.path));
      case TileType.CITY:
        return Image(image: AssetImage(Assets.tiles.city.path));
      case TileType.CAPITAL:
        return isAres
            ? Image(image: AssetImage(Assets.tiles.capitalAres.path))
            : Image(image: AssetImage(Assets.tiles.capital.path));
      case TileType.COMMERCIAL_DISTRICT: // Commercial District
        return isAres
            ? Stack(children: [
                Image(
                    image: AssetImage(Assets.tiles.comercialDistrictAres.path))
              ])
            : _getSpecialTile(
                Assets.tiles.specialTileIcons.commericalDistrict.path);
      case TileType.ECOLOGICAL_ZONE: // Ecological Zone
        return _getSpecialTile(
            Assets.tiles.specialTileIcons.ecologicalZone.path);
      case TileType.INDUSTRIAL_CENTER: // Industrial Center
        return _getSpecialTile(
            Assets.tiles.specialTileIcons.industrialCenter.path);
      case TileType.LAVA_FLOWS: // Lava Flows
        return _getSpecialTile(Assets.tiles.specialTileIcons.lavaFlows.path);
      case TileType.MINING_AREA:
        return _getSpecialTile(Assets.tiles.specialTileIcons.miningArea.path);
      case TileType.MINING_RIGHTS:
        return _getSpecialTile(Assets.tiles.specialTileIcons.miningArea.path);
      case TileType.MOHOLE_AREA:
        return _getSpecialTile(Assets.tiles.specialTileIcons.moholeArea.path);
      case TileType.NATURAL_PRESERVE:
        return _getSpecialTile(
            Assets.tiles.specialTileIcons.naturalPreserve.path);
      case TileType.NUCLEAR_ZONE:
        return _getSpecialTile(Assets.tiles.specialTileIcons.nuclearZone.path);
      case TileType.RESTRICTED_AREA:
        return _getSpecialTile(
            Assets.tiles.specialTileIcons.restrictedArea.path);
      case TileType.DEIMOS_DOWN:
        return _getSpecialTile(Assets.tiles.specialTileIcons.deimos.path);
      case TileType.GREAT_DAM:
        return _getSpecialTile(Assets.tiles.specialTileIcons.greatDam.path);
      case TileType.MAGNETIC_FIELD_GENERATORS:
        return _getSpecialTile(
            Assets.tiles.specialTileIcons.magneticFieldGen.path);
      case TileType.BIOFERTILIZER_FACILITY:
        return Image(
            image: AssetImage(Assets.tiles.biofertilizerFacility.path));
      case TileType.METALLIC_ASTEROID:
        return Image(image: AssetImage(Assets.tiles.metallicAsteroid.path));
      case TileType.SOLAR_FARM:
        return Image(image: AssetImage(Assets.tiles.solarFarm.path));
      case TileType.OCEAN_CITY:
        return Image(image: AssetImage(Assets.tiles.oceanCity.path));
      case TileType.OCEAN_FARM:
        return Image(image: AssetImage(Assets.tiles.oceanFarm.path));
      case TileType.OCEAN_SANCTUARY:
        return Image(image: AssetImage(Assets.tiles.oceanSanctuary.path));
      case TileType.DUST_STORM_MILD:
        return SizedBox.shrink();
      case TileType.DUST_STORM_SEVERE:
        return SizedBox.shrink();
      case TileType.EROSION_MILD:
        return SizedBox.shrink();
      case TileType.EROSION_SEVERE:
        return SizedBox.shrink();
      case TileType.MINING_STEEL_BONUS:
        return Image(image: AssetImage(Assets.tiles.miningSteelBonus.path));
      case TileType.MINING_TITANIUM_BONUS:
        return Image(image: AssetImage(Assets.tiles.miningTitaniumBonus.path));
      case TileType.MOON_MINE:
        return SizedBox.shrink();
      case TileType.MOON_HABITAT:
        return SizedBox.shrink();
      case TileType.MOON_ROAD:
        return SizedBox.shrink();
      case TileType.LUNA_TRADE_STATION:
        return Image(image: AssetImage(Assets.moon.lunaTradeStation.path));
      case TileType.LUNA_MINING_HUB:
        return Image(image: AssetImage(Assets.moon.lunaMiningHub.path));
      case TileType.LUNA_TRAIN_STATION:
        return Image(image: AssetImage(Assets.moon.lunaTrainStation.path));
      case TileType.LUNAR_MINE_URBANIZATION:
        return Image(image: AssetImage(Assets.moon.lunarMineUrbanization.path));
      case TileType.WETLANDS:
        return Image(image: AssetImage(Assets.pathfinders.wetlandsTile.path));
      case TileType.RED_CITY:
        return Image(image: AssetImage(Assets.pathfinders.redCityTile.path));
      case TileType.MARTIAN_NATURE_WONDERS:
        return Image(
            image: AssetImage(Assets.pathfinders.martianNatureWonders.path));
      case TileType.CRASHLANDING:
        return Image(image: AssetImage(Assets.pathfinders.crashlanding.path));
      case TileType.MARS_NOMADS:
        return SizedBox.shrink();
      case TileType.REY_SKYWALKER:
        return SizedBox.shrink();
      case TileType.MAN_MADE_VOLCANO:
        return _getSpecialTile(Assets.tiles.specialTileIcons.lavaFlows.path);
    }
  }
}
