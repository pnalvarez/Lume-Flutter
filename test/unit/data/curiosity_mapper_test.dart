import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/curiosity_mapper.dart';
import 'package:lume/layers/data/models/curiosity_data.dart';

void main() {
  test('CuriosityData.fromJson parses snake_case and round-trips', () {
    final data = CuriosityData.fromJson({
      'id': 'c-1',
      'image_url': 'https://img/1.png',
      'title': 'T',
      'content': 'C',
      'teaser': 'S',
      'opened': true,
    });

    expect(data.imageUrl, 'https://img/1.png');
    expect(data.opened, isTrue);
    expect(CuriosityData.fromJson(data.toJson()).title, 'T');
  });

  test('CuriosityData defaults opened to false when missing or null', () {
    expect(CuriosityData.fromJson({'id': 'a'}).opened, isFalse);
    expect(CuriosityData.fromJson({'id': 'a', 'opened': null}).opened, isFalse);
  });

  test('toDomain maps every field', () {
    final domain = CuriosityMapper.toDomain(
      const CuriosityData(
        id: 'c-1',
        imageUrl: 'https://img/1.png',
        title: 'T',
        content: 'C',
        teaser: 'S',
        opened: true,
      ),
    );

    expect(domain.id, 'c-1');
    expect(domain.imageUrl, 'https://img/1.png');
    expect(domain.hasImage, isTrue);
    expect(domain.title, 'T');
    expect(domain.content, 'C');
    expect(domain.teaser, 'S');
    expect(domain.opened, isTrue);
  });

  test('toDomain defaults null text and treats blank image as no image', () {
    final domain = CuriosityMapper.toDomain(
      const CuriosityData(id: 'c-2', imageUrl: '  '),
    );

    expect(domain.imageUrl, isNull);
    expect(domain.hasImage, isFalse);
    expect(domain.title, '');
    expect(domain.content, '');
    expect(domain.teaser, '');
    expect(domain.opened, isFalse);
  });

  test('CuriosityDomain.copyWith only changes opened', () {
    final domain = CuriosityMapper.toDomain(
      const CuriosityData(id: 'c-3', title: 'T'),
    );
    final opened = domain.copyWith(opened: true);

    expect(opened.opened, isTrue);
    expect(opened.id, 'c-3');
    expect(opened.title, 'T');
    expect(domain.copyWith().opened, isFalse);
  });
}
