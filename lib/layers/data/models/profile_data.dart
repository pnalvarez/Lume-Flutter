import 'package:json_annotation/json_annotation.dart';

part 'profile_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileData {
  const ProfileData({
    required this.id,
    this.email,
    this.fullName,
    this.trailStartedAt,
  });

  final String id;
  final String? email;
  final String? fullName;
  final DateTime? trailStartedAt;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
