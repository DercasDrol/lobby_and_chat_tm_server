abstract class AresGlobalParametersResponse {
  factory AresGlobalParametersResponse.fromJson({required json}) {
    if (json['oxygenDelta'] != null) {
      return OxygenDelta(json['oxygenDelta']);
    } else if (json['temperatureDelta'] != null) {
      return TemperatureDelta(json['temperatureDelta']);
    } else if (json['highOceanDelta'] != null) {
      return HighOceanDelta(json['highOceanDelta']);
    } else if (json['lowOceanDelta'] != null) {
      return LowOceanDelta(json['lowOceanDelta']);
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
  late final int value;
  factory LowOceanDelta(num) {
    return LowOceanDelta(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'lowOceanDelta': value,
    };
  }
}

class HighOceanDelta implements AresGlobalParametersResponse {
  late final int value;
  factory HighOceanDelta(num) {
    return HighOceanDelta(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'highOceanDelta': value,
    };
  }
}

class TemperatureDelta implements AresGlobalParametersResponse {
  late final int value;
  factory TemperatureDelta(num) {
    return TemperatureDelta(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'temperatureDelta': value,
    };
  }
}

class OxygenDelta implements AresGlobalParametersResponse {
  late final int value;
  factory OxygenDelta(num) {
    return OxygenDelta(_POSSIBLE_VALUES.contains(num) ? num : 0);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'oxygenDelta': value,
    };
  }
}
