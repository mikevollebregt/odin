import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:movement/infrastructure/repositories/dtos/reference_latlng_dto.dart';

import '../../dtos/sensor_stats_dto.dart';
import '../database.dart';
import '../tables/sensor_geolocation_table.dart';

part 'sensor_geolocation_dao.g.dart';

@DriftAccessor(tables: [SensorGeolocations])
class SensorGeolocationDao extends DatabaseAccessor<Database> with _$SensorGeolocationDaoMixin {
  SensorGeolocationDao(Database db) : super(db);

  Future<int> insertSensorGeolocation(SensorGeolocation sensorGeolocation) async => into(sensorGeolocations).insert(sensorGeolocation);

  Future<bool> replaceSensorGeolocation(SensorGeolocation sensorGeolocation) async => update(sensorGeolocations).replace(sensorGeolocation);

  Future<void> replaceBulkSensorGeolocation(Iterable<SensorGeolocation> sensorGeolocationList) async {
    await batch((batch) {
      batch.replaceAll(sensorGeolocations, sensorGeolocationList);
    });
  }

  Future<int> getSensorGeolocationCount() async => (await select(sensorGeolocations).get()).length;

  Future<ReferenceLatLngDto?> getReferenceLatLng(DateTime referenceDateMin, DateTime referenceDateMax) async {
    for (final minute in [2, 1, 0]) {
      final query = select(sensorGeolocations)
        ..where((s) => s.isNoise.equals(false))
        ..where((s) => s.deletedOn.isNull())
        ..where(
            (s) => s.createdOn.isBetween(Variable.withDateTime(referenceDateMin), Variable.withDateTime(referenceDateMax.subtract(Duration(minutes: minute)))))
        ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.desc)])
        ..limit(1);
      final sensorGeolocation = await query.getSingleOrNull();
      if (sensorGeolocation != null) return ReferenceLatLngDto(LatLng(sensorGeolocation.latitude, sensorGeolocation.longitude), sensorGeolocation.createdOn);
    }
    return null;
  }

  Future<SensorGeolocation?> getLastValidSensorGeolocation() async {
    return (select(sensorGeolocations)
          ..where((s) => s.isNoise.equals(false))
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<SensorGeolocation>> getSensorGeolocations(DateTime startTime, DateTime endTime) {
    return (select(sensorGeolocations)
          ..where((m) => m.createdOn.isBetween(Variable.withDateTime(startTime), Variable.withDateTime(endTime)))
          ..where((m) => m.deletedOn.isNull())
          ..where((m) => m.isNoise.equals(false))
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.asc)]))
        .get();
  }

  Future<List<SensorGeolocation>> findSensorGeolocations(String sensorType) {
    return (select(sensorGeolocations)
          ..where((m) => m.sensorType.equals(sensorType))
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.asc)]))
        .get();
  }

  Future<List<SensorGeolocation>> getAllSensorGeolocations() {
    return (select(sensorGeolocations)..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.asc)])).get();
  }

  Future<List<SensorGeolocation>> getUnsycnedSensorGeolocations(int limit) {
    return (select(sensorGeolocations)
          ..where((m) => m.synced.equals(false))
          ..limit(limit))
        .get();
  }

  Future<int> getSyncedCount() async => (await (select(sensorGeolocations)..where((m) => m.synced.equals(true))).get()).length;

  Future<int> getUnsyncedCount() async => (await (select(sensorGeolocations)..where((m) => m.synced.equals(false))).get()).length;

  Future<List<String>> _getSeenSensors() async {
    return (selectOnly(sensorGeolocations, distinct: true)..addColumns([sensorGeolocations.sensorType])).map((row) {
      return row.rawData.data.values.first as String;
    }).get();
  }

  Future<List<SensorGeolocation>> _getGeolocationsPerSensor(String sensorName, Expression<Object> sortedBy) async {
    return (select(sensorGeolocations)
          ..where((s) => s.sensorType.equals(sensorName))
          ..orderBy([(s) => OrderingTerm(expression: sortedBy, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<SensorStatsDto>> getSensorStats() async {
    final sensorNames = await _getSeenSensors();
    final sensorStatDtos = <SensorStatsDto>[];
    for (final sensorName in sensorNames) {
      final geolocationsByTime = await _getGeolocationsPerSensor(sensorName, sensorGeolocations.createdOn);
      final geolocationsByAccuracy = await _getGeolocationsPerSensor(sensorName, sensorGeolocations.accuracy);
      final lastSeen = geolocationsByTime[0].createdOn;
      final count = geolocationsByTime.length;
      sensorStatDtos.add(
        SensorStatsDto(
          name: sensorName,
          lastSeen: lastSeen,
          count: count,
          accuracy25Percentile: geolocationsByAccuracy[(count * 0.25).floor()].accuracy,
          accuracy50Percentile: geolocationsByAccuracy[(count * 0.50).floor()].accuracy,
          accuracy75Percentile: geolocationsByAccuracy[(count * 0.75).floor()].accuracy,
        ),
      );
    }
    return sensorStatDtos;
  }

  Future<SensorGeolocation?> getLastBackgroundSensorGeolocation() async {
    return (select(sensorGeolocations)
          ..where((s) => (s.sensorType.equals('GeolocatorPlatform')).not())
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }
}
