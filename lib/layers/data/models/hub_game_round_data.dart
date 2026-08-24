import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/models/game_data.dart';

part 'hub_game_round_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HubGameRoundData {
  const HubGameRoundData({
    required this.gameSlug,
    required this.gameName,
    this.games = const [],
  });

  final String gameSlug;
  final String gameName;

  @JsonKey(defaultValue: <GameItemData>[])
  final List<GameItemData> games;

  factory HubGameRoundData.fromJson(Map<String, dynamic> json) =>
      _$HubGameRoundDataFromJson(json);

  Map<String, dynamic> toJson() => _$HubGameRoundDataToJson(this);
}
