import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';

@immutable
final class GamesHubCardUi {
  const GamesHubCardUi({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.hubSection,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final String colorHex;
  final HubSection hubSection;

  factory GamesHubCardUi.fromDomain(HubGameDomain game) {
    return GamesHubCardUi(
      id: game.id,
      slug: game.slug,
      title: game.name,
      description: game.description,
      colorHex: game.colorHex,
      hubSection: game.hubSection,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesHubCardUi &&
      other.id == id &&
      other.slug == slug &&
      other.title == title &&
      other.description == description &&
      other.colorHex == colorHex &&
      other.hubSection == hubSection;

  @override
  int get hashCode =>
      Object.hash(id, slug, title, description, colorHex, hubSection);
}
