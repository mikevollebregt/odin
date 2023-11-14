class SensorStatsDto {
  final String name;
  final DateTime lastSeen;
  final int count;
  final double accuracy25Percentile;
  final double accuracy50Percentile;
  final double accuracy75Percentile;

  SensorStatsDto({
    required this.name,
    required this.lastSeen,
    required this.count,
    required this.accuracy25Percentile,
    required this.accuracy50Percentile,
    required this.accuracy75Percentile,
  });
}
