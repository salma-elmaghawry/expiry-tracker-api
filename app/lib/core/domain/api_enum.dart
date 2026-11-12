extension ApiEnumName on Enum {
  String get apiName => name[0].toUpperCase() + name.substring(1);
}

T enumFromApi<T extends Enum>(List<T> values, String apiName) {
  return values.firstWhere(
    (value) => value.apiName == apiName,
    orElse: () => throw FormatException('Unknown value: $apiName'),
  );
}

T? tryEnumFromApi<T extends Enum>(List<T> values, String? apiName) {
  if (apiName == null) return null;
  for (final value in values) {
    if (value.apiName == apiName) return value;
  }
  return null;
}
