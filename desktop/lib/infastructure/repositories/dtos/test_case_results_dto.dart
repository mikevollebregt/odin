import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';

class TestCaseResultsDTO {
  List<TrackedLocationDTO> validatedTrackedLocations;
  List<TrackedLocationDTO> generatedTrackedLocations;
  List<Map<TrackedLocationDTO, TrackedLocationDTO>> mappedTrackedLocations;

  List<TrackedMovementDTO> validatedTrackedMovement;
  List<TrackedMovementDTO> generatedTrackedMovement;
  List<Map<TrackedMovementDTO, TrackedMovementDTO>> mappedTrackedMovement;

  TestCaseResultsDTO(
      {required this.validatedTrackedLocations,
      required this.generatedTrackedLocations,
      required this.mappedTrackedLocations,
      required this.validatedTrackedMovement,
      required this.generatedTrackedMovement,
      required this.mappedTrackedMovement});
}
