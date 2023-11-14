import 'package:drift/drift.dart';

import '../../dtos/classified_period_dto.dart';
import '../../dtos/movement_dto.dart';
import '../../dtos/stop_dto.dart';
import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/google_maps_table.dart';
import '../tables/manual_geolocation_table.dart';
import '../tables/movement_table.dart';
import '../tables/reason_table.dart';
import '../tables/stop_table.dart';
import '../tables/vehicle_table.dart';
import 'classified_period_dto_dao.dart';

part 'user_update_dao.g.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Movements, Stops, Reasons, GoogleMapsDatas, ManualGeolocations, Vehicles])
class UserUpdateDao extends ClassifiedPeriodDtoDao with _$UserUpdateDaoMixin {
  UserUpdateDao(Database db) : super(db);

  void removeStop(StopDto stopDto) => _removeClassifiedPeriods([stopDto.classifiedPeriod]);

  void removeMovement(MovementDto movementDto) => _removeClassifiedPeriods([movementDto.classifiedPeriod]);

  // void addStop(StopDto stopDto) async {
  //   final classifiedPeriodId = await _addClassifiedPeriod(stopDto);
  //   final reasonId = stopDto.reason == null ? null : await into(reasons).insert(stopDto.reason!);
  //   final googleMapsDataId = stopDto.googleMapsData == null ? null : await into(googleMapsDatas).insert(stopDto.googleMapsData!);
  //   await into(stops).insert(
  //     StopsCompanion.insert(
  //       classifiedPeriodId: classifiedPeriodId,
  //       reasonId: Value(reasonId),
  //       googleMapsDataId: Value(googleMapsDataId),
  //     ),
  //   );
  // }

  // void addMovement(MovementDto movementDto) async {
  //   final classifiedPeriodId = await _addClassifiedPeriod(movementDto);
  //   final vehicleId = movementDto.vehicle == null ? null : await into(vehicles).insert(movementDto.vehicle!);
  //   await into(movements).insert(
  //     MovementsCompanion.insert(
  //       classifiedPeriodId: classifiedPeriodId,
  //       vehicleId: Value(vehicleId),
  //     ),
  //   );
  // }

  // void updateStop(StopDto stopDto) {
  //   removeStop(stopDto);
  //   addStop(stopDto);
  // }

  // void updateMovement(MovementDto movementDto) {
  //   removeMovement(movementDto);
  //   addMovement(movementDto);
  // }

  Future<bool> willOverwriteClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async {
    return (await _getFullyOverlappedClassifiedPeriods(classifiedPeriod.startDate, classifiedPeriod.endDate)).isNotEmpty;
  }

  void _removeClassifiedPeriods(List<ClassifiedPeriod> classifiedPeriodList) async {
    final deletedOn = DateTime.now();
    await batch((batch) {
      batch.replaceAll(
        classifiedPeriods,
        classifiedPeriodList.map(
          (c) => c.copyWith(deletedOn: deletedOn),
        ),
      );
    });
  }

  Future<int> _addClassifiedPeriod(ClassifiedPeriodDto classifiedPeriodDto) async {
    // _resolveTimeConflicts(classifiedPeriodDto.classifiedPeriod.startDate, classifiedPeriodDto.classifiedPeriod.endDate);
    final classifiedPeriodId = await into(classifiedPeriods).insert(classifiedPeriodDto.classifiedPeriod.copyWith(id: null));
    _addManualGeolocations(classifiedPeriodDto.manualGeolocations, classifiedPeriodId);
    return classifiedPeriodId;
  }

  void _addManualGeolocations(List<ManualGeolocation> manualGeolocationList, int classifiedPeriodId) async {
    await batch((batch) {
      batch.insertAll(
        manualGeolocations,
        manualGeolocationList.map(
          (m) => m.copyWith(classifiedPeriodId: classifiedPeriodId),
        ),
      );
    });
  }

  // void _resolveTimeConflicts(DateTime start, DateTime end) async {
  //   final fullyOverlapped = await _getFullyOverlappedClassifiedPeriods(start, end);
  //   final startOverlapped = await _getStartOverlappedClassifiedPeriods(start, end);
  //   final endOverlapped = await _getEndOverlappedClassifiedPeriods(start, end);
  //   final middleOverlapped = await _getMiddleOverlappedClassifiedPeriods(start, end);

  //   if (fullyOverlapped.isNotEmpty) _removeClassifiedPeriods(fullyOverlapped);
  //   if (startOverlapped != null) _updateClassifiedPeriod(startOverlapped.copyWith(startDate: end));
  //   if (endOverlapped != null) _updateClassifiedPeriod(endOverlapped.copyWith(endDate: start));
  //   if (middleOverlapped != null) _splitClassifiedPeriod(middleOverlapped, start, end);
  // }

  Future<List<ClassifiedPeriod>> _getFullyOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.startDate.isBiggerOrEqualValue(start))
          ..where((c) => c.endDate.isSmallerOrEqualValue(end)))
        .get();
  }

  Future<ClassifiedPeriod?> _getStartOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.startDate.isBiggerOrEqualValue(start))
          ..where((c) => c.startDate.isSmallerOrEqualValue(end))
          ..where((c) => c.endDate.isBiggerThanValue(end)))
        .getSingleOrNull();
  }

  Future<ClassifiedPeriod?> _getEndOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.endDate.isBiggerOrEqualValue(start))
          ..where((c) => c.endDate.isSmallerOrEqualValue(end))
          ..where((c) => c.startDate.isSmallerThanValue(start)))
        .getSingleOrNull();
  }

  Future<ClassifiedPeriod?> _getMiddleOverlappedClassifiedPeriods(DateTime start, DateTime end) async {
    return (select(classifiedPeriods)
          ..where((c) => c.endDate.isBiggerOrEqualValue(end))
          ..where((c) => c.startDate.isSmallerOrEqualValue(start)))
        .getSingleOrNull();
  }

  // void _updateClassifiedPeriod(ClassifiedPeriod classifiedPeriod) async {
  //   final classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
  //   if (classifiedPeriodDto is StopDto) updateStop(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod));
  //   if (classifiedPeriodDto is MovementDto) updateMovement(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod));
  // }

  // void _splitClassifiedPeriod(ClassifiedPeriod classifiedPeriod, DateTime start, DateTime end) async {
  //   final classifiedPeriodDto = await getClassifiedPeriodDto(classifiedPeriod);
  //   // TODO: Split up the ManualGeolocations here
  //   if (classifiedPeriodDto is StopDto) {
  //     removeStop(classifiedPeriodDto);
  //     addStop(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(endDate: start)));
  //     addStop(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(startDate: end)));
  //   }
  //   if (classifiedPeriodDto is MovementDto) {
  //     removeMovement(classifiedPeriodDto);
  //     addMovement(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(endDate: start)));
  //     addMovement(classifiedPeriodDto.copyWith(classifiedPeriod: classifiedPeriod.copyWith(startDate: end)));
  //   }
  // }
}
