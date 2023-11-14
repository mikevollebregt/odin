import 'package:desktop/infastructure/repositories/dtos/movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/stop_dto.dart';


class ValidatedPeriodDto {
  final List<MovementDto> movements;
  final List<StopDto> stops;

  ValidatedPeriodDto({
    required this.movements,
    required this.stops,
  });

  factory ValidatedPeriodDto.fromMap(Map<String, dynamic> json) =>
      ValidatedPeriodDto(movements: MovementDto.fromList(json["Movements"]), stops: StopDto.fromList(json["Stops"]));
}
