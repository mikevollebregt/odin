import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/device_table.dart';

part 'device_dao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <Database> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Devices])
class DevicesDao extends DatabaseAccessor<Database> with _$DevicesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  DevicesDao(Database db) : super(db);

  Future<Device?> getDeviceAsync() => (select(devices)..limit(1)).getSingleOrNull();
  Future<List<Device>> getDevicesAsync() => select(devices).get();
  Stream<List<Device>> watchAllDevicesAsync() => select(devices).watch();
  Future insertDeviceAsync(Device device) => into(devices).insert(device);
  Future updateDeviceAsync(Device device) => update(devices).replace(device);
  Future deleteDeviceAsync(Device device) => delete(devices).delete(device);
}
