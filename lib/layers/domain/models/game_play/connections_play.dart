final class ConnectionsPlayState {
  const ConnectionsPlayState({
    this.selectedLeftId,
    this.links = const {},
    this.linkOrder = const [],
  });

  final String? selectedLeftId;
  final Map<String, String> links;
  final List<String> linkOrder;

  ConnectionsPlayState copyWith({
    String? selectedLeftId,
    bool clearSelectedLeft = false,
    Map<String, String>? links,
    List<String>? linkOrder,
  }) {
    return ConnectionsPlayState(
      selectedLeftId: clearSelectedLeft
          ? null
          : (selectedLeftId ?? this.selectedLeftId),
      links: links ?? this.links,
      linkOrder: linkOrder ?? this.linkOrder,
    );
  }
}

final class ConnectionsPlayOutcome {
  const ConnectionsPlayOutcome({
    required this.state,
    this.answered = false,
    this.isCorrect = false,
  });

  final ConnectionsPlayState state;
  final bool answered;
  final bool isCorrect;
}
