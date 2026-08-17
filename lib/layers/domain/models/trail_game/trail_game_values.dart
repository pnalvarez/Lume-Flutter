/// Shared value objects used by [TrailGame] variants.
class SentenceBlank {
  const SentenceBlank({
    required this.order,
    required this.options,
    required this.correct,
  });

  final int order;
  final List<String> options;
  final String correct;
}

class ConnectionItem {
  const ConnectionItem({required this.id, required this.text});

  final String id;
  final String text;
}

class ConnectionPair {
  const ConnectionPair({
    required this.leftId,
    required this.rightId,
    this.explanation,
  });

  final String leftId;
  final String rightId;
  final String? explanation;
}

enum TrueOrMythVerdict {
  truth('true'),
  myth('myth'),
  partial('partial');

  const TrueOrMythVerdict(this.wireValue);

  final String wireValue;

  static TrueOrMythVerdict fromWire(String value) {
    final normalized = value.trim().toLowerCase();
    return switch (normalized) {
      'true' || 'verdade' => TrueOrMythVerdict.truth,
      'myth' || 'mito' => TrueOrMythVerdict.myth,
      'partial' || 'parcial' => TrueOrMythVerdict.partial,
      _ => throw FormatException('Unsupported verdict: $value'),
    };
  }
}

enum BattleCorrectSide {
  a('a'),
  b('b');

  const BattleCorrectSide(this.wireValue);

  final String wireValue;

  static BattleCorrectSide fromWire(String value) {
    final normalized = value.trim().toLowerCase();
    return switch (normalized) {
      'a' => BattleCorrectSide.a,
      'b' => BattleCorrectSide.b,
      _ => throw FormatException('Unsupported battle side: $value'),
    };
  }
}
