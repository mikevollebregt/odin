import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../dtos/stop_dto.dart';
import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/google_maps_table.dart';
import '../tables/manual_geolocation_table.dart';
import '../tables/movement_table.dart';
import '../tables/reason_table.dart';
import '../tables/stop_table.dart';
import '../tables/vehicle_table.dart';

part 'stop_dao.g.dart';

@DriftAccessor(
  tables: [ClassifiedPeriods, Movements, Stops, Reasons, GoogleMapsDatas, ManualGeolocations, Vehicles],
)
class StopDao extends DatabaseAccessor<Database> with _$StopDaoMixin {
  StopDao(Database db) : super(db);

  Future<void> removeStop(StopDto stopDto) async => db.classifiedPeriodDao.removeClassifiedPeriods([stopDto.classifiedPeriod]);

  Future<void> addStop(StopDto stopDto) async {
    return transaction(
      () async {
        final classifiedPeriodUuid = await db.classifiedPeriodDtoDao.addClassifiedPeriod(stopDto);
        final googleMapsDataUuid = stopDto.googleMapsData == null
            ? null
            : (await into(googleMapsDatas).insertReturning(
                GoogleMapsDatasCompanion.insert(
                  googleId: Value(stopDto.googleMapsData!.googleId),
                  address: Value(stopDto.googleMapsData!.address),
                  city: Value(stopDto.googleMapsData!.city),
                  postcode: Value(stopDto.googleMapsData!.postcode),
                  country: Value(stopDto.googleMapsData!.country),
                  name: Value(stopDto.googleMapsData!.name),
                ),
              ))
                .uuid;
        await into(stops).insert(
          StopsCompanion.insert(
            classifiedPeriodUuid: classifiedPeriodUuid,
            reasonId: stopDto.reason != null ? Value(stopDto.reason!.id) : Value.absent(),
            googleMapsDataUuid: Value(googleMapsDataUuid),
          ),
        );
      },
    );
  }

  void updateStop(StopDto stopDto, StopDto oldStopDto) {
    final _c = stopDto.classifiedPeriod;
    removeStop(oldStopDto);
    addStop(stopDto.copyWith(classifiedPeriod: _c.copyWith(uuid: Uuid().v4(), origin: Value(_c.uuid))));
  }

  Future<List<Stop>> getUnsycnedStops() async => (select(stops)..where((c) => c.synced.equals(false))).get();

  Future<void> setSynced(Stop stop) async => await update(stops).replace(stop.copyWith(synced: Value(true)));

  Future<void> automaticallyAddGoogleMapsData(StopDto stopDto, GoogleMapsData googleMapsData) async {
    final googleMapsDataUuid = (await into(googleMapsDatas).insertReturning(googleMapsData.copyWith(synced: Value(false)))).uuid;

    await (update(stops)..where((s) => s.uuid.equals(stopDto.stopUuid))).write(
      StopsCompanion.insert(
        uuid: Value(stopDto.stopUuid),
        classifiedPeriodUuid: stopDto.classifiedPeriod.uuid,
        reasonId: Value(stopDto.reason?.id),
        googleMapsDataUuid: Value(googleMapsDataUuid),
        synced: Value(false),
      ),
    );
  }
}
