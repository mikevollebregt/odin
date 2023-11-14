import 'package:drift/drift.dart';
import 'package:movement/presentation/widgets/date_picker_widget/util/date_extensions.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uuid/uuid.dart';

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

  // Methods related to displaying the DTO

  Future<List<ClassifiedPeriodDto>> getClassifiedPeriodDtos() async {
    return (select(classifiedPeriods)
          ..where((c) => c.deletedOn.isNull())
          ..orderBy([
            (c) => OrderingTerm(expression: c.endDate),
          ]))
        .asyncMap((_c) => getClassifiedPeriodDto(_c))
        .get();
  }

  Stream<List<ClassifiedPeriodDto>> streamClassifiedPeriodDtos(DateTime dateTime) async* {
    final _classifiedPeriodsStream = (select(classifiedPeriods)
          ..where((c) =>
              (c.startDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.startDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.endDate.isBiggerOrEqual(Variable(dateTime.startOfDay())) & c.endDate.isSmallerOrEqual(Variable(dateTime.endOfDay()))) |
              (c.startDate.isSmallerThan(Variable(dateTime.startOfDay())) & c.endDate.isBiggerThan(Variable(dateTime.endOfDay()))))
          ..where((c) => c.deletedOn.isNull())
          ..orderBy([
            (c) => OrderingTerm(expression: c.endDate),
          ]))
        .watch()
        .debounce(const Duration(milliseconds: 100));
    yield* _classifiedPeriodsStream.asyncMap((_classifiedPeriods) => Future.wait(_classifiedPeriods.map(_getCachedClassifiedPeriodDto)));
  }

  Stream<ClassifiedPeriodDto?> streamClassifiedPeriodDto(String uuid) async* {
    final _classifiedPeriodsStream = (select(classifiedPeriods)..where((c) => c.uuid.equals(uuid))).watchSingleOrNull();
    yield* _classifiedPeriodsStream.asyncMap((e) => e != null ? getClassifiedPeriodDto(e) : null);
  }

  Future<ClassifiedPeriodDto> _getCachedClassifiedPeriodDto(ClassifiedPeriod classifiedPeriod) async {
    var classifiedPeriodDto = db.classifiedPeriodDtoCache.get(classifiedPeriod);
    if (classifiedPeriodDto != null) return classifiedPeriodDto;
    classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
    db.classifiedPeriodDtoCache.add(classifiedPeriodDto);
    return classifiedPeriodDto;
  }

  Future<ClassifiedPeriodDto> getClassifiedPeriodDto(ClassifiedPeriod classifiedPeriod) async {
    final manualGeolocations = await _getManualGeolocations(classifiedPeriod);
    final sensorGeolocations = await _getSensorGeolocations(classifiedPeriod);
    return await (select(classifiedPeriods).join([
      leftOuterJoin(movements, movements.classifiedPeriodUuid.equalsExp(classifiedPeriods.uuid)),
      leftOuterJoin(vehicles, vehicles.id.equalsExp(movements.vehicleId)),
      leftOuterJoin(stops, stops.classifiedPeriodUuid.equalsExp(classifiedPeriods.uuid)),
      leftOuterJoin(reasons, reasons.id.equalsExp(stops.reasonId)),
      leftOuterJoin(googleMapsDatas, googleMapsDatas.uuid.equalsExp(stops.googleMapsDataUuid)),
    ])
          ..where(classifiedPeriods.uuid.equals(classifiedPeriod.uuid)))
        .map((row) {
      if (row.readTableOrNull(stops) != null) {
        return StopDto(
          stopUuid: row.readTable(stops).uuid,
          reason: row.readTableOrNull(reasons),
          googleMapsData: row.readTableOrNull(googleMapsDatas),
          classifiedPeriod: row.readTable(classifiedPeriods),
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );
      } else {
        return MovementDto(
          movementUuid: row.readTable(movements).uuid,
          vehicle: row.readTableOrNull(vehicles),
          classifiedPeriod: row.readTable(classifiedPeriods),
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );
      }
    }).getSingle() as ClassifiedPeriodDto;
  }

  Future<List<ManualGeolocation>> _getManualGeolocations(ClassifiedPeriod classifiedPeriod) async {
    return (select(manualGeolocations)..where((s) => s.classifiedPeriodUuid.equals(classifiedPeriod.uuid))).get();
  }

  Future<List<SensorGeolocation>> _getSensorGeolocations(ClassifiedPeriod classifiedPeriod) async {
    return (select(sensorGeolocations)
          ..where((c) => c.createdOn.isBiggerOrEqualValue(classifiedPeriod.startDate))
          ..where((c) => c.createdOn.isSmallerOrEqualValue(classifiedPeriod.endDate)))
        .get();
  }

  //  Methods related to user updates

  Future<bool> willOverwriteClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async {
    return (await getFullyOverlappedClassifiedPeriods(classifiedPeriod.startDate, classifiedPeriod.endDate)).isNotEmpty;
  }

  Future<String> addClassifiedPeriod(ClassifiedPeriodDto classifiedPeriodDto) async {
    await resolveTimeConflicts(classifiedPeriodDto.classifiedPeriod.startDate, classifiedPeriodDto.classifiedPeriod.endDate);
    final classifiedPeriodUuid = (await into(classifiedPeriods).insertReturning(
      ClassifiedPeriodsCompanion.insert(
        uuid: Value(classifiedPeriodDto.classifiedPeriod.uuid),
        origin: Value(classifiedPeriodDto.classifiedPeriod.origin),
        confirmed: Value(classifiedPeriodDto.classifiedPeriod.confirmed),
        createdOn: classifiedPeriodDto.classifiedPeriod.createdOn,
        deletedOn: Value(classifiedPeriodDto.classifiedPeriod.deletedOn),
        endDate: classifiedPeriodDto.classifiedPeriod.endDate,
        startDate: classifiedPeriodDto.classifiedPeriod.startDate,
        synced: Value(false),
        trackedDayUuid: Value(classifiedPeriodDto.classifiedPeriod.trackedDayUuid),
      ),
    ))
        .uuid;
    await addManualGeolocations(classifiedPeriodDto.manualGeolocations, classifiedPeriodUuid);
    return classifiedPeriodUuid;
  }

  Future<void> addManualGeolocations(List<ManualGeolocation> manualGeolocationList, String classifiedPeriodUuid) async {
    await batch((batch) {
      batch.insertAll(
          manualGeolocations,
          manualGeolocationList
              .map((m) => ManualGeolocationsCompanion.insert(
                    classifiedPeriodUuid: classifiedPeriodUuid,
                    createdOn: m.createdOn,
                    latitude: m.latitude,
                    longitude: m.longitude,
                  ))
              .toList());
    });
  }

  Future<void> resolveTimeConflicts(DateTime start, DateTime end) async {
    final fullyOverlapped = await getFullyOverlappedClassifiedPeriods(start, end);
    final startOverlapped = await getStartOverlappedClassifiedPeriods(start, end);
    final endOverlapped = await getEndOverlappedClassifiedPeriods(start, end);
    final middleOverlapped = await getMiddleOverlappedClassifiedPeriods(start, end);

    if (fullyOverlapped.isNotEmpty) await db.classifiedPeriodDao.removeClassifiedPeriods(fullyOverlapped);
    if (startOverlapped != null) await updateClassifiedPeriod(startOverlapped.copyWith(startDate: end));
    if (endOverlapped != null) await updateClassifiedPeriod(endOverlapped.copyWith(endDate: start));
    if (middleOverlapped != null) await splitClassifiedPeriod(middleOverlapped, start, end);
  }

  Future<List<ClassifiedPeriod>> getFullyOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.startDate.isBiggerOrEqualValue(start))
          ..where((c) => c.endDate.isSmallerOrEqualValue(end))
          ..where((c) => c.deletedOn.isNull()))
        .get();
  }

  Future<ClassifiedPeriod?> getStartOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.startDate.isBiggerOrEqualValue(start))
          ..where((c) => c.startDate.isSmallerThanValue(end))
          ..where((c) => c.endDate.isBiggerThanValue(end))
          ..where((c) => c.deletedOn.isNull()))
        .getSingleOrNull();
  }

  Future<ClassifiedPeriod?> getEndOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.endDate.isBiggerThanValue(start))
          ..where((c) => c.endDate.isSmallerOrEqualValue(end))
          ..where((c) => c.startDate.isSmallerThanValue(start))
          ..where((c) => c.deletedOn.isNull()))
        .getSingleOrNull();
  }

  Future<ClassifiedPeriod?> getMiddleOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.startDate.isSmallerThanValue(start))
          ..where((c) => c.endDate.isBiggerThanValue(end))
          ..where((c) => c.deletedOn.isNull()))
        .getSingleOrNull();
  }

  Future<void> updateClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async {
    final classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
    if (classifiedPeriodDto is StopDto) db.stopDao.updateStop(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod), classifiedPeriodDto);
    if (classifiedPeriodDto is MovementDto)
      db.movementDao.updateMovement(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod), classifiedPeriodDto);
  }

  Future<void> splitClassifiedPeriod(ClassifiedPeriod classifiedPeriod, DateTime start, DateTime end) async {
    final classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
    // TODO: Split up the ManualGeolocations here
    if (classifiedPeriodDto is StopDto) {
      db.stopDao.removeStop(classifiedPeriodDto);
      await db.stopDao.addStop(
          classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(endDate: start, uuid: Uuid().v4(), origin: Value((classifiedPeriod.uuid)))));
      await db.stopDao.addStop(
          classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(startDate: end, uuid: Uuid().v4(), origin: Value((classifiedPeriod.uuid)))));
    }
    if (classifiedPeriodDto is MovementDto) {
      db.movementDao.removeMovement(classifiedPeriodDto);
      await db.movementDao.addMovement(
          classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(endDate: start, uuid: Uuid().v4(), origin: Value((classifiedPeriod.uuid)))));
      await db.movementDao.addMovement(
          classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(startDate: end, uuid: Uuid().v4(), origin: Value((classifiedPeriod.uuid)))));
    }
  }
}
