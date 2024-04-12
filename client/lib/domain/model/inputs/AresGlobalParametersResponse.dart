abstract class AresGlobalParametersResponse {
  factory AresGlobalParametersResponse.fromJson({required json}) {
    if (json['oxygenDelta'] != null) {
      return OxygenDelta.fromNum(json['oxygenDelta'] as int);
    } else if (json['temperatureDelta'] != null) {
      return TemperatureDelta.fromNum(json['temperatureDelta'] as int);
    } else if (json['highOceanDelta'] != null) {
      return HighOceanDelta.fromNum(json['highOceanDelta'] as int);
    } else if (json['lowOceanDelta'] != null) {
      return LowOceanDelta.fromNum(json['lowOceanDelta'] as int);
    } else {
      throw Exception('Unknown AresGlobalParametersResponse');
    }
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}

const _POSSIBLE_VALUES = [-1, 0, 1];

class LowOceanDelta implements AresGlobalParametersResponse {
  final int value;

  LowOceanDelta._(this.value);

  factory LowOceanDelta.fromNum(num) {
    return LowOceanDelta._(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'lowOceanDelta': value,
    };
  }
}

class HighOceanDelta implements AresGlobalParametersResponse {
  final int value;
  HighOceanDelta._(this.value);
  factory HighOceanDelta.fromNum(num) {
    return HighOceanDelta._(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'highOceanDelta': value,
    };
  }
}

class TemperatureDelta implements AresGlobalParametersResponse {
  final int value;

  TemperatureDelta._(this.value);
  factory TemperatureDelta.fromNum(num) {
    return TemperatureDelta._(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'temperatureDelta': value,
    };
  }
}

class OxygenDelta implements AresGlobalParametersResponse {
  final int value;

  OxygenDelta._(this.value);
  factory OxygenDelta.fromNum(num) {
    return OxygenDelta._(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'oxygenDelta': value,
    };
  }
}
