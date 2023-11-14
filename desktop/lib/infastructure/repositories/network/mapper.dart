import 'package:desktop/infastructure/repositories/dtos/location_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_latlon_dto.dart';

class Mapper {
  static T fromMap<T>(Map<String, dynamic> map) {
    switch (T) {
      case TrackedDayDTO:
        return TrackedDayDTO.fromMap(map) as T;
      case TrackedLocationDTO:
        return TrackedLocationDTO.fromMap(map) as T;
      case TestCaseDTO:
        return TestCaseDTO.fromMap(map) as T;
      case TrackedMovementDTO:
        return TrackedMovementDTO.fromMap(map) as T;
      case TrackedMovementLatlngDTO:
        return TrackedMovementLatlngDTO.fromMap(map) as T;
      case LocationDTO:
        return LocationDTO.fromMap(map) as T;
      default:
        return map as T;
    }
  }
}
