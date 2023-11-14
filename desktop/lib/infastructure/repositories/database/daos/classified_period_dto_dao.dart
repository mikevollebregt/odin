import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../dtos/classified_period_dto.dart';
import '../../dtos/movement_dto.dart';
import '../../dtos/stop_dto.dart';
import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/google_maps_table.dart';
import '../tables/manual_geolocation_table.dart';
import '../tables/movement_table.dart';
import '../tables/reason_table.dart';
import '../tables/sensor_geolocation_table.dart';
import '../tables/stop_table.dart';
import '../tables/vehicle_table.dart';

part 'classified_period_dto_dao.g.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Movements, Stops, Reasons, GoogleMapsDatas, ManualGeolocations, Vehicles, SensorGeolocations])
class ClassifiedPeriodDtoDao extends DatabaseAccessor<Database> with _$ClassifiedPeriodDtoDaoMixin {
  ClassifiedPeriodDtoDao(Database db) : super(db);

  Stream<ClassifiedPeriodDto> streamClassifiedPeriodDto(int id) async* {
    final _classifiedPeriodsStream = (select(classifiedPeriods)..where((c) => c.id.equals(id))).watchSingle();
    yield* _classifiedPeriodsStream.asyncMap(getClassifiedPeriodDto);
  }

  Stream<List<ClassifiedPeriodDto>> streamClassifiedPeriodDtos(DateTime dateTime) async* {
    final _classifiedPeriodsStream = (select(classifiedPeriods)
          ..where((c) => c.startDate.year.equals(dateTime.year))
          ..where((c) => c.startDate.month.equals(dateTime.month))
          ..where((c) => c.startDate.day.equals(dateTime.day) | c.endDate.day.equals(dateTime.day))
          ..where((c) => c.deletedOn.isNull()))
        .watch()
        .debounce(const Duration(milliseconds: 100));
    yield* _classifiedPeriodsStream.asyncMap((_classifiedPeriods) => Future.wait(_classifiedPeriods.map(_getCachedClassifiedPeriodDto)));
  }

  final _cachedClassifiedPeriodDtos = <int, Map<int, ClassifiedPeriodDto>>{};

  Future<ClassifiedPeriodDto> _getCachedClassifiedPeriodDto(ClassifiedPeriod classifiedPeriod) async {
    final firstKey = classifiedPeriod.id!;
    final secondKey = classifiedPeriod.endDate.microsecondsSinceEpoch;
    if (_cachedClassifiedPeriodDtos.containsKey(firstKey)) {
      final _innerCache = _cachedClassifiedPeriodDtos[firstKey]!;
      if (_innerCache.containsKey(secondKey)) return _innerCache[secondKey]!;
      _cachedClassifiedPeriodDtos.remove(firstKey);
    }
    final classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
    _cachedClassifiedPeriodDtos[firstKey] = {secondKey: classifiedPeriodDto};
    return classifiedPeriodDto;
  }

  Future<ClassifiedPeriodDto> getClassifiedPeriodDto(ClassifiedPeriod classifiedPeriod) async {
    final manualGeolocations = await _getManualGeolocations(classifiedPeriod);
    final sensorGeolocations = await _getSensorGeolocations(classifiedPeriod);
    return (select(classifiedPeriods).join([
      leftOuterJoin(movements, movements.classifiedPeriodId.equalsExp(classifiedPeriods.id)),
      leftOuterJoin(vehicles, vehicles.id.equalsExp(movements.vehicleId)),
      leftOuterJoin(stops, stops.classifiedPeriodId.equalsExp(classifiedPeriods.id)),
      leftOuterJoin(reasons, reasons.id.equalsExp(stops.reasonId)),
      leftOuterJoin(googleMapsDatas, googleMapsDatas.id.equalsExp(stops.googleMapsDataId)),
    ])
          ..where(classifiedPeriods.id.equals(classifiedPeriod.id)))
        .map((row) {
      if (row.readTableOrNull(stops) != null) {
        return StopDto(
          stopId: row.readTable(stops).id!,
          reason: null,
          googleMapsData: row.readTableOrNull(googleMapsDatas),
          classifiedPeriod: row.readTable(classifiedPeriods),
          manualGeolocations: manualGeolocations,
          sensorGeolocations: [],
        );
      } else {
        return MovementDto(
          movementId: row.readTable(movements).id!,
          vehicle: null,
          classifiedPeriod: row.readTable(classifiedPeriods),
          manualGeolocations: manualGeolocations,
          sensorGeolocations: [],
        );
      }
    }).getSingle();
  }

  Future<List<ManualGeolocation>> _getManualGeolocations(ClassifiedPeriod classifiedPeriod) async {
    return (select(manualGeolocations)..where((s) => s.classifiedPeriodId.equals(classifiedPeriod.id))).get();
  }

  Future<List<SensorGeolocation>> _getSensorGeolocations(ClassifiedPeriod classifiedPeriod) async {
    return (select(sensorGeolocations)
          ..where((c) => c.createdOn.isBiggerOrEqualValue(classifiedPeriod.startDate))
          ..where((c) => c.createdOn.isSmallerOrEqualValue(classifiedPeriod.endDate)))
        .get();
  }
}
