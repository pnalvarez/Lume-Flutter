import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/preview_slides_domain.dart';

void main() {
  group('PreviewSlidesDomain', () {
    test('all filled returns the three texts in order', () {
      const sut = PreviewSlidesDomain(
        introduction: 'Intro',
        elaboration: 'Elab',
        conclusion: 'Concl',
      );

      expect(sut.slides, ['Intro', 'Elab', 'Concl']);
      expect(sut.hasSlides, isTrue);
    });

    test('skips empty texts and keeps order', () {
      const sut = PreviewSlidesDomain(introduction: 'Intro', conclusion: 'End');

      expect(sut.slides, ['Intro', 'End']);
      expect(sut.hasSlides, isTrue);
    });

    test('none filled has no slides', () {
      const sut = PreviewSlidesDomain();

      expect(sut.slides, isEmpty);
      expect(sut.hasSlides, isFalse);
    });
  });
}
