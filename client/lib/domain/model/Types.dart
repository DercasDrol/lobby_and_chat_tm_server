import 'package:equatable/equatable.dart';

class SpaceId extends Equatable {
  final String? id;
  SpaceId(this.id);
  factory SpaceId.fromString(String? string) {
    return SpaceId(RegExp(r'[0-9][0-9]').hasMatch((string ?? "")) &&
            (string ?? "").length == 2
        ? string
        : null);
  }
  @override
  String toString() => id ?? 'undefined SpaceId';
  bool isMoonSpace() {
    return (this.id ?? "").startsWith('m');
  }

  bool isMarsSpace() {
    return !this.isMoonSpace();
  }

  Map<String, dynamic> toJson() {
    return {
      'spaceId': id,
    };
  }

  @override
  List<Object?> get props => [id];
}

class PlayerId implements ParticipantId {
  final String? id;
  PlayerId(this.id);
  factory PlayerId.fromString(String? string) {
    return PlayerId((string ?? "").startsWith('p') ? string : null);
  }

  @override
  String toString() => id ?? 'undefined PlayerId';

  @override
  bool get isPlayer => true;

  @override
  bool get isSpectator => false;

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => false;
}

class GameId {
  final String? id;
  GameId(this.id);
  factory GameId.fromString(String? string) {
    return GameId((string ?? "").startsWith('g') ? string : null);
  }
  @override
  String toString() => id ?? 'undefined GameId';
}

class SpectatorId implements ParticipantId {
  final String? id;
  SpectatorId(this.id);
  factory SpectatorId.fromString(String? string) {
    return SpectatorId((string ?? "").startsWith('s') ? string : null);
  }
  @override
  String toString() => id ?? 'undefined SpectatorId';

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => false;

  @override
  bool get isPlayer => false;

  @override
  bool get isSpectator => true;
}

class ParticipantId extends Equatable {
  final String? id;
  ParticipantId(this.id);
  factory ParticipantId.fromString(String? string) {
    return (string ?? "").startsWith('p')
        ? PlayerId(string)
        : SpectatorId(string);
  }
  @override
  String toString() => id ?? 'undefined ParticipantId';

  bool get isPlayer => this is PlayerId;
  bool get isSpectator => this is SpectatorId;

  @override
  List<Object?> get props => [id];
}
