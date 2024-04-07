enum WaitingForModelResult {
  GO,
  REFRESH,
  WAIT;

  static const _TO_STRING_MAP = {
    GO: 'GO',
    REFRESH: 'REFRESH',
    WAIT: 'WAIT',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();

  static WaitingForModelResult? fromString(String? value) =>
      _TO_ENUM_MAP[value];
  static WaitingForModelResult? fromJson(Map<String, dynamic> json) =>
      json['result'] == null
          ? null
          : WaitingForModelResult.fromString(json['result'] as String);
}
