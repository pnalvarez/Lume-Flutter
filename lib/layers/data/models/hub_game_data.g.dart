// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubGameData _$HubGameDataFromJson(Map<String, dynamic> json) => HubGameData(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  colorHex: json['color_hex'] as String,
  hubSection: json['hub_section'] as String,
  orderIndex: (json['order_index'] as num).toInt(),
);

Map<String, dynamic> _$HubGameDataToJson(HubGameData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color_hex': instance.colorHex,
      'hub_section': instance.hubSection,
      'order_index': instance.orderIndex,
    };
