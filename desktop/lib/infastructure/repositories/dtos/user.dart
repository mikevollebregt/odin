import 'package:json_annotation/json_annotation.dart';


part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'Username')
  String? username;
  @JsonKey(name: 'ID')
  int? id;

  User({this.username, this.id});

  //TODO: fix duplicate methods
  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
