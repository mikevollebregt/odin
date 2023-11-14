import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:movement/infrastructure/repositories/database/daos/movement_dao.dart';
import 'package:movement/infrastructure/repositories/database/daos/stop_dao.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'package:uuid/uuid.dart';

import 'cache/classified_period_dto_cache.dart';
import 'daos/classified_period_dao.dart';
import 'daos/classified_period_dto_dao.dart';
import 'daos/device_dao.dart';
import 'daos/google_maps_data_dao.dart';
import 'daos/log_dao.dart';
import 'daos/manual_geolocation_dao.dart';
import 'daos/reason_dao.dart';
import 'daos/sensor_geolocation_dao.dart';
import 'daos/token_dao.dart';
import 'daos/tracked_day_dao.dart';
import 'daos/vehicle_dao.dart';
import 'tables/classified_period_table.dart';
import 'tables/device_table.dart';
import 'tables/google_maps_table.dart';
import 'tables/log_table.dart';
import 'tables/manual_geolocation_table.dart';
import 'tables/movement_table.dart';
import 'tables/reason_table.dart';
import 'tables/sensor_geolocation_table.dart';
import 'tables/stop_table.dart';
import 'tables/token_table.dart';
import 'tables/tracked_day_table.dart';
import 'tables/vehicle_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Devices,
    Logs,
    Tokens,
    ClassifiedPeriods,
    ManualGeolocations,
    Movements,
    Reasons,
    SensorGeolocations,
    Stops,
    TrackedDays,
    Vehicles,
    GoogleMapsDatas,
  ],
  daos: [
    ReasonDao,
    VehicleDao,
    DevicesDao,
    LogsDao,
    TokensDao,
    SensorGeolocationDao,
    ManualGeolocationDao,
    ClassifiedPeriodDao,
    ClassifiedPeriodDtoDao,
    TrackedDayDao,
    MovementDao,
    StopDao,
    GoogleMapsDataDao,
  ],
  include: {'tables/index.drift'},
)
class Database extends _$Database {
  final classifiedPeriodDtoCache = ClassifiedPeriodDtoCache();

  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getDatabasesPath();
    final file = File(p.join(dbFolder, 'db.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}
