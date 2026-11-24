import 'package:json_annotation/json_annotation.dart';

part 'curiosity_data.g.dart';

/// Row of `get_daily_curiosity`. Every field but [id] tolerates null/missing.
@JsonSerializable(fieldRename: FieldRename.snake)
class CuriosityData {
  const CuriosityData({
    required this.id,
    this.imageUrl,
    this.title,
    this.content,
    this.teaser,
    this.opened = false,
  });

  final String id;
  final String? imageUrl;
  final String? title;
  final String? content;
  final String? teaser;

  @JsonKey(defaultValue: false)
  final bool opened;

  factory CuriosityData.fromJson(Map<String, dynamic> json) =>
      _$CuriosityDataFromJson(json);

  Map<String, dynamic> toJson() => _$CuriosityDataToJson(this);

  CuriosityData copyWith({bool? opened}) {
    return CuriosityData(
      id: id,
      imageUrl: imageUrl,
      title: title,
      content: content,
      teaser: teaser,
      opened: opened ?? this.opened,
    );
  }
}
