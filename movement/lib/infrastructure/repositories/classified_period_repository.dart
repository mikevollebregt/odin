import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:movement/infrastructure/repositories/dtos/movement_dto.dart';
import 'package:movement/infrastructure/repositories/dtos/reference_latlng_dto.dart';
import 'package:movement/infrastructure/repositories/google_maps_repository.dart';

import '../services/stop_classifier/parameters.dart';
import 'database/database.dart';
import 'dtos/classified_period_dto.dart';
import 'dtos/stop_dto.dart';
import 'network/classified_period_api.dart';
import 'tracked_day_repository.dart';

class ClassifiedPeriodRepository {
  final Database _database;
  final TrackedDayRepository _trackedDayRepository;
  final ClassifiedPeriodApi _classifiedPeriodApi;
  final GoogleMapsRepository _googleMapsRepository;

  ClassifiedPeriodRepository(this._database, this._trackedDayRepository, this._classifiedPeriodApi, this._googleMapsRepository);

  Future<void> syncClassifiedPeriods() async {
    final unsycnedClassifiedPeriods = await _database.classifiedPeriodDao.getUnsyncedClassifiedPeriods();
    for (final unsynced in unsycnedClassifiedPeriods) {
      final _response = await _classifiedPeriodApi.sync(unsynced);
      if (_response.isOk) await _database.classifiedPeriodDao.replaceClassifiedPeriod(unsynced.copyWith(synced: Value(true)));
    }
  }

  Stream<List<ClassifiedPeriodDto>> streamClassifiedPeriodDtos(DateTime dateTime) async* {
    yield* _database.classifiedPeriodDtoDao.streamClassifiedPeriodDtos(dateTime);
  }

  Future<List<ClassifiedPeriodDto>> addGoogleMapsDataToStops() async {
    final classifiedPeriodDtos = await _database.classifiedPeriodDtoDao.getClassifiedPeriodDtos();
    for (final classifiedPeriodDto in classifiedPeriodDtos) {
      if (classifiedPeriodDto is StopDto) {
        if (classifiedPeriodDto.googleMapsData == null) {
          final googleMapsDto =
              await _googleMapsRepository.latLongSearch(LatLng(classifiedPeriodDto.centroid!.latitude, classifiedPeriodDto.centroid!.longitude));
          if (googleMapsDto != null) {
            _database.stopDao.automaticallyAddGoogleMapsData(classifiedPeriodDto, googleMapsDto.toGoogleMapsData());
            _database.classifiedPeriodDtoCache.remove(classifiedPeriodDto);
          }
        }
      }
    }
    return classifiedPeriodDtos;
  }

  Stream<ClassifiedPeriodDto?> streamClassifiedPeriodDto(String uuid) async* {
    yield* _database.classifiedPeriodDtoDao.streamClassifiedPeriodDto(uuid);
  }

  Future<ReferenceLatLngDto?> getReferenceLatLng() async {
    final referenceDateMin = getReferenceDateMin();
    final referenceDateMax = getReferenceDateMax();

    final manualLatLng = await _database.manualGeolocationDao.getReferenceLatLng(referenceDateMin, referenceDateMax);
    if (manualLatLng != null) return manualLatLng;

    final stopDto = await _getLastPeriodIfStopDto();
    if (stopDto != null) return ReferenceLatLngDto(stopDto.centroid!, stopDto.classifiedPeriod.endDate);

    return _database.sensorGeolocationDao.getReferenceLatLng(referenceDateMin, referenceDateMax);
  }

  Future<SensorGeolocation?> getLastValidSensorGeolocation() async => _database.sensorGeolocationDao.getLastValidSensorGeolocation();

  Future<bool> _isBadPeriod(ClassifiedPeriod classifiedPeriodDao) async {
    final stopDurationInSeconds = classifiedPeriodDao.endDate.difference(classifiedPeriodDao.startDate).inSeconds;
    if (stopDurationInSeconds > 150) return false;
    if (classifiedPeriodDao.confirmed == true) return false;
    if ((await _database.classifiedPeriodDao.getClassifiedPeriods()).length <= 1) return false;
    return true;
  }

  Future<void> _removeBadStop(ClassifiedPeriod classifiedPeriod) async {
    final StopDto stopDto = await _database.classifiedPeriodDtoDao.getClassifiedPeriodDto(classifiedPeriod) as StopDto;
    await _database.stopDao.removeStop(stopDto);
  }

  Future<void> _removeBadMovement(ClassifiedPeriod classifiedPeriod) async {
    final MovementDto movementDto = await _database.classifiedPeriodDtoDao.getClassifiedPeriodDto(classifiedPeriod) as MovementDto;
    await _database.movementDao.removeMovement(movementDto);
  }

  Future<void> upsertClassifiedPeriod(bool isStop, SensorGeolocation sensorGeolocation) async {
    final lastClassifiedPeriod = await _database.classifiedPeriodDao.getLastClassifiedPeriod();
    if (await _shouldAddNewClassifiedPeriod(lastClassifiedPeriod, isStop)) {
      final trackedDayUuid = await _trackedDayRepository.getTrackedDayUuid(sensorGeolocation.createdOn);
      if (isStop) {
        if (lastClassifiedPeriod != null && await _isBadPeriod(lastClassifiedPeriod)) {
          await (_removeBadMovement(lastClassifiedPeriod));
          final lastStop = await _database.classifiedPeriodDao.getLastClassifiedPeriod();
          if (lastStop != null) {
            await _database.classifiedPeriodDao.replaceClassifiedPeriod(lastStop.copyWith(endDate: sensorGeolocation.createdOn, synced: Value(false)));
          }
        } else {
          await _database.classifiedPeriodDao.addStop(trackedDayUuid, sensorGeolocation);
        }
      } else {
        // If movement
        if (lastClassifiedPeriod != null && await _isBadPeriod(lastClassifiedPeriod)) {
          await _removeBadStop(lastClassifiedPeriod);
          final lastMovement = await _database.classifiedPeriodDao.getLastClassifiedPeriod();
          if (lastMovement != null) {
            await _database.classifiedPeriodDao.replaceClassifiedPeriod(lastMovement.copyWith(endDate: sensorGeolocation.createdOn, synced: Value(false)));
          }
        } else {
          await _database.classifiedPeriodDao.addMovement(trackedDayUuid, sensorGeolocation);
        }
      }
      await addGoogleMapsDataToStops();
    } else {
      await _database.classifiedPeriodDao.replaceClassifiedPeriod(lastClassifiedPeriod!.copyWith(endDate: sensorGeolocation.createdOn, synced: Value(false)));
    }
  }

  Future<bool> _shouldAddNewClassifiedPeriod(ClassifiedPeriod? lastClassifiedPeriod, bool newLocationIsStop) async {
    if (lastClassifiedPeriod == null) return true;
    final lastClassifiedPeriodIsStop = await _database.classifiedPeriodDao.isStop(lastClassifiedPeriod);
    return lastClassifiedPeriodIsStop != newLocationIsStop;
  }

  Future<List<ClassifiedPeriod>> getClassifiedPeriodsById(List<String> Ids) async {
    return await _database.classifiedPeriodDao.getClassifiedPeriodsByIds(Ids);
  }

  Future removeClassifiedPeriods(List<ClassifiedPeriod> periods) async {
    await _database.classifiedPeriodDao.removeClassifiedPeriods(periods);
  }

  Future<StopDto?> _getLastPeriodIfStopDto() async {
    final lastClassifiedPeriod = await _database.classifiedPeriodDao.getLastClassifiedPeriod();
    if (lastClassifiedPeriod == null) return null;
    final classifiedPeriodDto = await _database.classifiedPeriodDtoDao.getClassifiedPeriodDto(lastClassifiedPeriod);
    if (classifiedPeriodDto is StopDto) return classifiedPeriodDto;
    return null;
  }
}
