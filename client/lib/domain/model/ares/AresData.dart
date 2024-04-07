import 'package:mars_flutter/domain/model/Types.dart';

class AresData {
  bool includeHazards;
  List<HazardConstraint> hazardData;
  List<MilestoneCount> milestoneResults;

  AresData(
      {required this.includeHazards,
      required this.hazardData,
      required this.milestoneResults});

  static fromJson(Map<String, dynamic> json) {
    return AresData(
      includeHazards: json['includeHazards'],
      hazardData: json['hazardData']
          .map((e) => HazardConstraint.fromJson(e))
          .toList()
          .cast<HazardConstraint>(),
      milestoneResults: json['milestoneResults']
          .map((e) => MilestoneCount.fromJson(e))
          .toList()
          .cast<MilestoneCount>(),
    );
  }
}

class HazardConstraint {
  int threshold;
  bool available;

  HazardConstraint({required this.threshold, required this.available});

  static HazardConstraint fromJson(Map<String, dynamic> json) {
    return HazardConstraint(
      threshold: json['threshold'] as int,
      available: json['available'] as bool,
    );
  }
}

class ErosionOceanCount extends HazardConstraint {
  ErosionOceanCount({required int threshold, required bool available})
      : super(threshold: threshold, available: available);
}

class RemoveDustStormsOceanCount extends HazardConstraint {
  RemoveDustStormsOceanCount({required int threshold, required bool available})
      : super(threshold: threshold, available: available);
}

class SevereErosionTemperature extends HazardConstraint {
  SevereErosionTemperature({required int threshold, required bool available})
      : super(threshold: threshold, available: available);
}

class SevereDustStormOxygen extends HazardConstraint {
  SevereDustStormOxygen({required int threshold, required bool available})
      : super(threshold: threshold, available: available);
}

class MilestoneCount {
  PlayerId id;
  int count;

  MilestoneCount({required this.id, required this.count});

  static MilestoneCount fromJson(Map<String, dynamic> json) {
    return MilestoneCount(
      id: PlayerId.fromString(json['id']),
      count: json['count'] as int,
    );
  }
}
