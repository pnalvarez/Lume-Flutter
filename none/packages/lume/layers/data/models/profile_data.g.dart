// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  id: json['id'] as String,
  email: json['email'] as String?,
  fullName: json['full_name'] as String?,
  trailStartedAt: json['trail_started_at'] == null
      ? null
      : DateTime.parse(json['trail_started_at'] as String),
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'trail_started_at': instance.trailStartedAt?.toIso8601String(),
    };
