import 'package:mars_flutter/domain/model/Color.dart';

abstract class IMaAndPartyScore {
  final PlayerColor color;
  final int number;

  IMaAndPartyScore({required this.color, required this.number});
}
