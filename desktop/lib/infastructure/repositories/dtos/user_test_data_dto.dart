import 'package:desktop/infastructure/repositories/dtos/user_test_day_data_dto.dart';

class UserTestDataDTO {
  String sdk;
  String brand;
  String model;
  String user;
  int userId;
  List<UserTestDayDataDTO> userTestDaysDataDTO;

  UserTestDataDTO({required this.sdk, required this.brand, required this.model, required this.user, required this.userTestDaysDataDTO, required this.userId});

  factory UserTestDataDTO.fromMap(Map<String, dynamic> map) => UserTestDataDTO(
      sdk: map['Sdk'],
      brand: map['Brand'],
      model: map['Model'],
      user: map['User'],
      userId: map['UserId'],
      userTestDaysDataDTO: UserTestDayDataDTO.fromList(map["UserTestDaysDataDTO"]));

  // Map<String, dynamic> toMap() => _$UserDTOToJson(this);
}
