import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/ma_model.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';

class PresentationMaInfo {
  final List<MaModel> ma;
  final List<MilestoneAwardName>? availableMa;
  final Function(String)? onConfirm;
  final List<PlayerColor>? playerAwardsOrder;
  static const int milestoneCost = 8;
  static const List<int> awardsCost = [8, 14, 20];
  PresentationMaInfo({
    required this.ma,
    required this.availableMa,
    this.onConfirm,
    this.playerAwardsOrder,
  });
}
