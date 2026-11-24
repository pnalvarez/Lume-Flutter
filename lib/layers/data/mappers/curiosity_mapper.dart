import 'package:lume/layers/data/models/curiosity_data.dart';
import 'package:lume/layers/domain/models/curiosity/curiosity_domain.dart';

abstract final class CuriosityMapper {
  const CuriosityMapper._();

  static Curiosity toDomain(CuriosityData data) {
    final image = data.imageUrl?.trim();
    return Curiosity(
      id: data.id,
      imageUrl: image == null || image.isEmpty ? null : image,
      title: data.title ?? '',
      content: data.content ?? '',
      teaser: data.teaser ?? '',
      opened: data.opened,
    );
  }
}
