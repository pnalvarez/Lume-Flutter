/// Catalog entry for the games tab hub.
class HubGameDomain {
  const HubGameDomain({
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
  final HubSection hubSection;
  final int orderIndex;
}

enum HubSection {
  general,
  visual;

  static HubSection fromWire(String value) {
    return switch (value.trim()) {
      'visual' => HubSection.visual,
      'general' => HubSection.general,
      _ => throw FormatException('Unsupported hub_section: $value'),
    };
  }

  String get wireValue => switch (this) {
    HubSection.general => 'general',
    HubSection.visual => 'visual',
  };
}
