import 'package:json_annotation/json_annotation.dart';

part 'arcade_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ArcadeRecordData {
  const ArcadeRecordData({this.bestRounds = 0});

  @JsonKey(defaultValue: 0)
  final int bestRounds;

  factory ArcadeRecordData.fromJson(Map<String, dynamic> json) =>
      _$ArcadeRecordDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArcadeRecordDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ArcadeRoundResultData {
  const ArcadeRoundResultData({this.xpAwarded = 0, this.isRecordRound = false});

  @JsonKey(defaultValue: 0)
  final int xpAwarded;

  @JsonKey(defaultValue: false)
  final bool isRecordRound;

  factory ArcadeRoundResultData.fromJson(Map<String, dynamic> json) =>
      _$ArcadeRoundResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArcadeRoundResultDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ArcadeRecordResultData {
  const ArcadeRecordResultData({
    this.bestRounds = 0,
    this.previousBestRounds = 0,
    this.isNewRecord = false,
  });

  @JsonKey(defaultValue: 0)
  final int bestRounds;

  @JsonKey(defaultValue: 0)
  final int previousBestRounds;

  @JsonKey(defaultValue: false)
  final bool isNewRecord;

  factory ArcadeRecordResultData.fromJson(Map<String, dynamic> json) =>
      _$ArcadeRecordResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArcadeRecordResultDataToJson(this);
}
