import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../database.dart';
import '../tables/sensor_geolocation_table.dart';

part 'sensor_geolocation_dao.g.dart';

@DriftAccessor(tables: [SensorGeolocations])
class SensorGeolocationDao extends DatabaseAccessor<Database> with _$SensorGeolocationDaoMixin {
  SensorGeolocationDao(Database db) : super(db);

  Future<int> insertSensorGeolocation(SensorGeolocation sensorGeolocation) async => into(sensorGeolocations).insert(sensorGeolocation);

  Future<bool> replaceSensorGeolocation(SensorGeolocation sensorGeolocation) async => update(sensorGeolocations).replace(sensorGeolocation);

  Future<int> getSensorGeolocationCount() async => (await select(sensorGeolocations).get()).length;

  Future<LatLng?> getReferenceLatLng(DateTime referenceDateMin, DateTime referenceDateMax) async {
    for (final minute in [2, 1, 0]) {
      final query = select(sensorGeolocations)
        ..where((s) => s.isNoise.equals(false))
        ..where((s) => s.deletedOn.isNull())
        ..where(
            (s) => s.createdOn.isBetween(Variable.withDateTime(referenceDateMin), Variable.withDateTime(referenceDateMax.subtract(Duration(minutes: minute)))))
        ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.desc)])
        ..limit(1);
      final sensorGeolocation = await query.getSingleOrNull();
      if (sensorGeolocation != null) return LatLng(sensorGeolocation.latitude, sensorGeolocation.longitude);
    }
    return null;
  }

  Future<List<SensorGeolocation>> getSensorGeolocations(DateTime startTime, DateTime endTime) {
    //TODO: should we convert startTime and endTime to utc?
    return (select(sensorGeolocations)
          ..where((m) => m.createdOn.isBetween(Variable.withDateTime(startTime), Variable.withDateTime(endTime)))
          ..where((m) => m.deletedOn.isNull())
          ..where((m) => m.isNoise.equals(false))
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.asc)]))
        .get();
  }

  Future<List<SensorGeolocation>> getUnsycnedSensorGeolocations() {
    return (select(sensorGeolocations)
          ..where((m) => m.synced.equals(false))
          ..orderBy([(s) => OrderingTerm(expression: s.createdOn, mode: OrderingMode.asc)]))
        .get();
  }
}
