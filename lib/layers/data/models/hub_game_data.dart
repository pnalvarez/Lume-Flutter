import 'package:json_annotation/json_annotation.dart';

part 'hub_game_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HubGameData {
  const HubGameData({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.icon,
    required this.colorHex,
    required this.hubSection,
    required this.orderIndex,
  });

  final String id;
  final String slug;
  final String name;
  final String description;
  final String icon;
  final String colorHex;
  final String hubSection;
  final int orderIndex;

  factory HubGameData.fromJson(Map<String, dynamic> json) =>
      _$HubGameDataFromJson(json);

  Map<String, dynamic> toJson() => _$HubGameDataToJson(this);
}
