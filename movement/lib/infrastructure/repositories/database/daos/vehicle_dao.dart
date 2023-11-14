import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/vehicle_table.dart';

part 'vehicle_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehicleDao extends DatabaseAccessor<Database> with _$VehicleDaoMixin {
  VehicleDao(Database db) : super(db);

  Future<List<Vehicle>> getVehicles() => select(vehicles).get();

  Future<int> insertVehicle(Vehicle vehicle) => into(vehicles).insert(vehicle);
}
