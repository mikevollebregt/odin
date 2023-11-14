import '../services/device_service.dart';
import 'database/database.dart';
import 'dtos/device_dto.dart';
import 'network/device_api.dart';

class DeviceRepository {
  final DeviceApi _deviceApi;
  final Database _database;
  final DeviceService _deviceService;

  DeviceRepository(this._deviceApi, this._database, this._deviceService);

  Future<DeviceDTO> getDeviceDTO() async {
    final device = await (_database.devicesDao.getDeviceAsync() as Future<Device>);
    final deviceDTO = DeviceDTO.fromDevice(device);

    return deviceDTO;
  }

  Future<List<DeviceDTO>> getDevicesAsync() async {
    final response = await _deviceApi.getDevices();
    return response.payload!;
  }

  Future checkIfDeviceIsStored() async {
    final devices = await _database.devicesDao.getDevicesAsync();

    if (devices.isEmpty) {
      final deviceDTO = await _deviceService.getDeviceAsync();

      final device = Device(
          model: deviceDTO!.model,
          brand: deviceDTO.brand,
          androidId: deviceDTO.androidId,
          device: deviceDTO.device,
          product: deviceDTO.product,
          version: deviceDTO.version,
          secureId: deviceDTO.secureId,
          sdk: deviceDTO.sdk,
          width: deviceDTO.width,
          height: deviceDTO.height,
          widthLogical: deviceDTO.widthLogical,
          heightLogical: deviceDTO.heightLogical,
          sensorLock: false,
          logLock: false);
      await _database.devicesDao.insertDeviceAsync(device);
      await _deviceApi.insertDevice(deviceDTO);
    }
  }
}
