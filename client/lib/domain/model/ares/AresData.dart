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
      hazardData: json['hazardData'].runtimeType == {}.runtimeType
          ? json['hazardData']
              .map((type, e) => HazardConstraint.fromJson(type, e))
              .cast<HazardConstraint>()
              .toList()
          : [],
      milestoneResults: json['milestoneResults'].runtimeType == [].runtimeType
          ? json['milestoneResults']
              .map((e) => MilestoneCount.fromJson(e))
              .cast<MilestoneCount>()
              .toList()
          : [],
    );
  }
}

abstract class HazardConstraint {
  int threshold;
  bool available;

  HazardConstraint({required this.threshold, required this.available});

  factory HazardConstraint.fromJson(String type, Map<String, dynamic> json) {
    final threshold = json['threshold'] as int;
    final available = json['available'] as bool;
    switch (type) {
      case 'erosionOceanCount':
        return ErosionOceanCount(threshold: threshold, available: available);
      case 'removeDustStormsOceanCount':
        return RemoveDustStormsOceanCount(
            threshold: threshold, available: available);
      case 'severeErosionTemperature':
        return SevereErosionTemperature(
            threshold: threshold, available: available);
      case 'severeDustStormOxygen':
        return SevereDustStormOxygen(
            threshold: threshold, available: available);
      default:
        throw Exception('Unknown HazardConstraint type: $type');
    }
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
