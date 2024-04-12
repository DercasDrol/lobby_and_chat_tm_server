import 'package:mars_flutter/domain/model/Types.dart';

class LoadGameFormModel {
  final GameId gameId;
  final int rollbackCount;
  LoadGameFormModel({
    required this.gameId,
    required this.rollbackCount,
  });
}
