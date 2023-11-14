import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'address_dto.dart';

part 'googlemaps_dto.g.dart';

@JsonSerializable()
class GoogleMapsDTO {
  final String placeId;
  final double? lat;
  final double? lon;
  final String? displayName;
  final AddressDTO address;

  GoogleMapsDTO({
    required this.placeId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.address,
  });

  factory GoogleMapsDTO.fromString(String json) => _$GoogleMapsDTOFromJson(jsonDecode(json) as Map<String, dynamic>);

  factory GoogleMapsDTO.fromMap(Map<String, dynamic> map) => _$GoogleMapsDTOFromJson(map);

  Map<String, dynamic> toJson() => _$GoogleMapsDTOToJson(this);

  GoogleMapsData toGoogleMapsData() => GoogleMapsData(
        uuid: Uuid().v4(),
        googleId: placeId,
        address: address.address,
        city: address.city,
        postcode: address.postcode,
        country: address.country,
        name: displayName,
        synced: false,
      );
}
