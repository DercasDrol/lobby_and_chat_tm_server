import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';

class PresentationTurmoilInfo {
  final TurmoilModel turmoilModel;
  final void Function(PartyName)? onSendDelegate;
  final void Function()? onApplyPolicyAction;
  final List<PartyName>? availableParties;
  final int? delegateCost;
  PresentationTurmoilInfo({
    required this.turmoilModel,
    this.onSendDelegate,
    this.onApplyPolicyAction,
    required this.availableParties,
    this.delegateCost,
  });
}
