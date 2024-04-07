import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/SpaceModel.dart';

class PresentationPlanetInfoCN extends ChangeNotifier {
  static final Map<SpaceId, String> spaceIdToText = {
    SpaceId('01'): 'Ganymede Colony',
    SpaceId('02'): 'Phobos Space\nHaven',
    SpaceId('69'): 'Stanford Torus',
    SpaceId('70'): 'Luna Metropolis',
    SpaceId('71'): 'Dawn City',
    SpaceId('72'): 'Stratopolis',
    SpaceId('73'): 'Maxwell Base',
    SpaceId('74'): 'Martian Transhipment\nStation',
    SpaceId('75'): 'Ceres Spaceport',
    SpaceId('76'): 'Dyson Screens',
    SpaceId('77'): 'Lunar Embassy',
    SpaceId('78'): 'Venera Base',
  };

  List<SpaceModel> _spaceModels;
  List<SpaceId>? _availableSpaces;
  PlayerColor? _activePlayer;
  Function(SpaceId spaceId)? _onConfirm;

  PlayerColor? get activePlayer => _activePlayer;
  set activePlayer(PlayerColor? value) {
    _activePlayer = value;
    notifyListeners();
  }

  List<SpaceModel> get spaceModels => _spaceModels;
  set spaceModels(List<SpaceModel> value) {
    _spaceModels = value;
    notifyListeners();
  }

  Function(SpaceId spaceId)? get onConfirm => _onConfirm;
  set onConfirm(Function(SpaceId spaceId)? value) {
    _onConfirm = value;
    notifyListeners();
  }

  List<SpaceId>? get availableSpaces => _availableSpaces;
  set availableSpaces(List<SpaceId>? value) {
    _availableSpaces = value;
    notifyListeners();
  }

  PresentationPlanetInfoCN({
    required List<SpaceModel> spaceModels,
    List<SpaceId>? availableSpaces,
    Function(SpaceId spaceId)? onConfirm,
    PlayerColor? activePlayer,
  })  : _availableSpaces = availableSpaces,
        _onConfirm = onConfirm,
        _spaceModels = spaceModels,
        _activePlayer = activePlayer;
}
