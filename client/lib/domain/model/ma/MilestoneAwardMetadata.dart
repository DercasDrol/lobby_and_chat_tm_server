import 'package:mars_flutter/domain/model/ma/AwardName.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneName.dart';

class MilestoneAwardMetadata {
  final MilestoneAwardName name;
  final String description;

  MilestoneAwardMetadata({
    required this.name,
    required this.description,
  });

  static List<MilestoneAwardMetadata> _milestoneAwards = [];
  static List<MilestoneAwardMetadata> get allMilestoneAwards =>
      _milestoneAwards;
  static set allMilestoneAwards(List<MilestoneAwardMetadata> value) {
    _milestoneAwards = value;
  }

  factory MilestoneAwardMetadata.fromJson(Map<String, dynamic> json) {
    MilestoneName? milestone = MilestoneName.fromString(json['name'] as String);
    AwardName? award = AwardName.fromString(json['name'] as String);
    return MilestoneAwardMetadata(
      name: (milestone ?? award!) as MilestoneAwardName,
      description: json['description'] as String,
    );
  }
}
