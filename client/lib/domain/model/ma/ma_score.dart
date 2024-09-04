import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/i_ma_and_party_score.dart';

class MaScore implements IMaAndPartyScore {
  final PlayerColor color;
  final int number;

  MaScore({required this.color, required this.number});
}
