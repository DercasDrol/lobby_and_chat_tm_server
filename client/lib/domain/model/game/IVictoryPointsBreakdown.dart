class DetailsCard {
  final String cardName;
  final int victoryPoint;

  DetailsCard({
    required this.cardName,
    required this.victoryPoint,
  });

  static fromJson(Map<String, dynamic> e) {
    return DetailsCard(
      cardName: e['cardName'] as String,
      victoryPoint: e['victoryPoint'] as int,
    );
  }
}

class DetailsPlanetaryTrack {
  final String tag;
  final int points;

  DetailsPlanetaryTrack({
    required this.tag,
    required this.points,
  });

  static fromJson(Map<String, dynamic> e) {
    return DetailsPlanetaryTrack(
      tag: e['tag'] as String,
      points: e['points'] as int,
    );
  }
}

class IVictoryPointsBreakdown {
  final int terraformRating;
  final int milestones;
  final int awards;
  final int greenery;
  final int city;
  final int escapeVelocity;
  final int moonHabitats;
  final int moonMines;
  final int moonRoads;
  final int planetaryTracks;
  final int victoryPoints;
  final int total;
  final List<DetailsCard> detailsCards;
  final List<String> detailsMilestones;
  final List<String> detailsAwards;
  final List<DetailsPlanetaryTrack> detailsPlanetaryTracks;

  IVictoryPointsBreakdown({
    required this.terraformRating,
    required this.milestones,
    required this.awards,
    required this.greenery,
    required this.city,
    required this.escapeVelocity,
    required this.moonHabitats,
    required this.moonMines,
    required this.moonRoads,
    required this.planetaryTracks,
    required this.victoryPoints,
    required this.total,
    required this.detailsCards,
    required this.detailsMilestones,
    required this.detailsAwards,
    required this.detailsPlanetaryTracks,
  });

  static fromJson(Map<String, dynamic> json) {
    return IVictoryPointsBreakdown(
      terraformRating: json['terraformRating'] as int,
      milestones: json['milestones'] as int,
      awards: json['awards'] as int,
      greenery: json['greenery'] as int,
      city: json['city'] as int,
      escapeVelocity: json['escapeVelocity'] as int,
      moonHabitats: json['moonHabitats'] as int,
      moonMines: json['moonMines'] as int,
      moonRoads: json['moonRoads'] as int,
      planetaryTracks: json['planetaryTracks'] as int,
      victoryPoints: json['victoryPoints'] as int,
      total: json['total'] as int,
      detailsCards: (json['detailsCards'])
          .map((e) => DetailsCard.fromJson(e as Map<String, dynamic>))
          .cast<DetailsCard>()
          .toList(),
      detailsMilestones: (json['detailsMilestones'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      detailsAwards: (json['detailsAwards'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      detailsPlanetaryTracks: (json['detailsPlanetaryTracks'])
          .map((e) => DetailsPlanetaryTrack.fromJson(e as Map<String, dynamic>))
          .cast<DetailsPlanetaryTrack>()
          .toList(),
    );
  }
}
