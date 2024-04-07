import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/constants.dart';

enum ExpansionType {
  CORPORATE_ERA,
  PRELUDE,
  PRELUDE2,
  VENUS_NEXT,
  TURMOIL,
  COLONIES,
  PROMO,
  ARES,
  COMMUNITY,
  MOON,
  PATHFINDERS,
  CEO,
  STARWARS,
  UNDERWORLD;

  String get name {
    switch (this) {
      case ExpansionType.CORPORATE_ERA:
        return 'Corporate Era';
      case ExpansionType.PRELUDE:
        return 'Prelude';
      case ExpansionType.PRELUDE2:
        return 'Prelude 2(β)';
      case ExpansionType.VENUS_NEXT:
        return 'Venus Next';
      case ExpansionType.COLONIES:
        return 'Colonies';
      case ExpansionType.TURMOIL:
        return 'Turmoil';
      case ExpansionType.PROMO:
        return 'Promos';
      case ExpansionType.ARES:
        return 'Ares';
      case ExpansionType.COMMUNITY:
        return 'Community';
      case ExpansionType.MOON:
        return 'The Moon';
      case ExpansionType.PATHFINDERS:
        return 'Pathfinders';
      case ExpansionType.CEO:
        return 'CEOs';
      case ExpansionType.STARWARS:
        return 'Star Wars(β)';
      case ExpansionType.UNDERWORLD:
        return 'Underworld(β)';
    }
  }

  String get typeImage {
    switch (this) {
      case ExpansionType.CORPORATE_ERA:
        return Assets.expansionIcons.expansionIconCorporateEra.path;
      case ExpansionType.PRELUDE:
        return Assets.expansionIcons.expansionIconPrelude.path;
      case ExpansionType.PRELUDE2:
        return Assets.expansionIcons.expansionIconPrelude2.path;
      case ExpansionType.VENUS_NEXT:
        return Assets.expansionIcons.expansionIconVenus.path;
      case ExpansionType.COLONIES:
        return Assets.expansionIcons.expansionIconColonies.path;
      case ExpansionType.TURMOIL:
        return Assets.expansionIcons.expansionIconTurmoil.path;
      case ExpansionType.PROMO:
        return Assets.expansionIcons.expansionIconPromo.path;
      case ExpansionType.ARES:
        return Assets.expansionIcons.expansionIconAres.path;
      case ExpansionType.COMMUNITY:
        return Assets.expansionIcons.expansionIconCommunity.path;
      case ExpansionType.MOON:
        return Assets.expansionIcons.expansionIconThemoon.path;
      case ExpansionType.PATHFINDERS:
        return Assets.expansionIcons.expansionIconPathfinders.path;
      case ExpansionType.CEO:
        return Assets.expansionIcons.expansionIconCeo.path;
      case ExpansionType.STARWARS:
        return Assets.expansionIcons.expansionIconStarwars.path;
      case ExpansionType.UNDERWORLD:
        return Assets.expansionIcons.expansionIconUnderworld.path;
    }
  }

  String? get descriptionUrl {
    switch (this) {
      case ExpansionType.CORPORATE_ERA:
        return null;
      case ExpansionType.PRELUDE:
        return null;
      case ExpansionType.PRELUDE2:
        return null;
      case ExpansionType.VENUS_NEXT:
        return null;
      case ExpansionType.COLONIES:
        return null;
      case ExpansionType.TURMOIL:
        return null;
      case ExpansionType.PROMO:
        return PROMO_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.ARES:
        return ARES_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.COMMUNITY:
        return COMMUNITY_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.MOON:
        return MOON_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.PATHFINDERS:
        return PATHFINDERS_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.CEO:
        return CEO_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.STARWARS:
        return STARWARS_EXPANSION_DESCRIPTION_URL;
      case ExpansionType.UNDERWORLD:
        return UNDERWORLD_EXPANSION_DESCRIPTION_URL;
    }
  }
}
