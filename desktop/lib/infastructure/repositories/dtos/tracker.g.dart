// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tracker _$TrackerFromJson(Map<String, dynamic> json) => Tracker(
      json['BatteryLevel'] as int,
      json['Date'] as int,
    );

Map<String, dynamic> _$TrackerToJson(Tracker instance) => <String, dynamic>{
      'BatteryLevel': instance.batteryLevel,
      'Date': instance.date,
    };
