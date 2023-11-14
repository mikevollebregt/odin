import 'package:desktop/infastructure/repositories/dtos/reason_dto.dart';


class ReasonClassifier {
  ReasonClassifier();

  ReasonDTO getPossibleReason(List<String> pointsOfInterest) {
    return ReasonDTO(key: "Unknown");
  }
}
