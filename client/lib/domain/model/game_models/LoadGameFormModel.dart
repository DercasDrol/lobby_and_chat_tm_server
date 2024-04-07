import 'package:mars_flutter/domain/model/Types.dart';

class LoadGameFormModel {
  late final GameId gameId;
  late final int rollbackCount;
  LoadGameFormModel({
    required this.gameId,
    required this.rollbackCount,
  });
}
