/// Submodule preview split into introduction / elaboration / conclusion.
class PreviewSlidesDomain {
  const PreviewSlidesDomain({
    this.introduction = '',
    this.elaboration = '',
    this.conclusion = '',
  });

  final String introduction;
  final String elaboration;
  final String conclusion;

  /// Slide texts in display order, skipping empty ones.
  List<String> get slides => [
    for (final text in [introduction, elaboration, conclusion])
      if (text.isNotEmpty) text,
  ];

  /// True when at least one slide text is non-empty.
  bool get hasSlides => slides.isNotEmpty;
}
