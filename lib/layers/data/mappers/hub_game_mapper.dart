import 'package:lume/layers/data/models/hub_game_data.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';

abstract final class HubGameMapper {
  static HubGameDomain toDomain(HubGameData data) {
    return HubGameDomain(
      id: data.id,
      slug: data.slug,
      name: data.name,
      description: data.description,
      icon: data.icon,
      colorHex: data.colorHex,
      hubSection: HubSection.fromWire(data.hubSection),
      orderIndex: data.orderIndex,
    );
  }
}
