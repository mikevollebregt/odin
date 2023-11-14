import 'database/database.dart';
import 'network/vehicle_api.dart';

class VehicleRepository {
  final Database _database;
  final VehicleApi _vehicleApi;

  VehicleRepository(this._database, this._vehicleApi);

  Future<List<Vehicle>?> getVehicles() async {
    final vehicles = await _database.vehicleDao.getVehicles();
    if (vehicles.isNotEmpty) return vehicles;

    final response = await _vehicleApi.getVehicleDtos();
    final vehicleList = response.payload!;
    vehicleList.sort((a, b) => a.id.compareTo(b.id));
    for (final vehicleDto in response.payload!) {
      await _database.vehicleDao.insertVehicle(vehicleDto.toVehicle());
    }

    final insertedVehicles = await _database.vehicleDao.getVehicles();
    if (insertedVehicles.isNotEmpty) return insertedVehicles;
    return null;
  }
}
