/// A short historical fun fact assigned to the user for a given day.
class CuriosityDomain {
  const CuriosityDomain({
    required this.id,
    required this.title,
    required this.content,
    required this.teaser,
    required this.opened,
    this.imageUrl,
  });

  final String id;

  /// Optional: some curiosities have no illustration.
  final String? imageUrl;
  final String title;
  final String content;
  final String teaser;

  /// True once the user dismissed the dialog for this curiosity.
  final bool opened;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  CuriosityDomain copyWith({bool? opened}) {
    return CuriosityDomain(
      id: id,
      imageUrl: imageUrl,
      title: title,
      content: content,
      teaser: teaser,
      opened: opened ?? this.opened,
    );
  }
}
