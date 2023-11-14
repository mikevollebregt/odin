import 'dart:io';
import 'dart:math';

import 'package:desktop/infastructure/repositories/database/daos/algo_state/algo_state_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/location/location_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/token/token_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/tracked_day/tracked_day_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/tracked_location/tracked_location_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/tracked_movement/tracked_movement_dao.dart';
import 'package:desktop/infastructure/repositories/database/daos/tracked_movement_latlng_dao.dart/tracked_movement_latlng_dao.dart';
import 'package:desktop/infastructure/repositories/database/tables/algo_state_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/classified_period_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/google_maps_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/location_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/manual_geolocation_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/movement_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/reason_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/sensor_geolocation_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/stop_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/token_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_day_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_location_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_movement_latlngs.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_movement_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/vehicle_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:path/path.dart' as p;

import 'daos/classified_period_dao.dart';
import 'daos/classified_period_dto_dao.dart';
import 'daos/manual_geolocation_dao.dart';
import 'daos/sensor_geolocation_dao.dart';
import 'daos/tracked_day_dao.dart';
import 'daos/user_update_dao.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final script = File(Platform.script.toFilePath());
    final random = Random().nextInt(600);
    final file = File(p.join(script.path.replaceFirst("main.dart", ""), '/generated_databases/${random}db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  ClassifiedPeriods,
  ManualGeolocations,
  Movements,
  Reasons,
  SensorGeolocations,
  Stops,
  TrackedDays,
  Vehicles,
  GoogleMapsDatas,
  TrackedDays,
  TrackedLocations,
  TrackedMovements,
  TrackedMovementLatLngs,
  AlgoStates,
  Locations,
  Tokens
], daos: [
  TrackedDaysDao,
  TrackedLocationsDao,
  TrackedMovementsDao,
  TrackedMovementLatLngsDao,
  AlgoStatesDao,
  LocationsDao,
  TokensDao,
  SensorGeolocationDao,
  ManualGeolocationDao,
  ClassifiedPeriodDao,
  TrackedDayDao,
  UserUpdateDao,
  ClassifiedPeriodDtoDao,
])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
