import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/organisms/navigation/page_header.dart';

@RoutePage()
class CategoryPreferencesPage extends StatelessWidget {
  const CategoryPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PageHeader(title: 'Categorias'),
      body: Center(
        child: Text(
          'Escolha de categorias',
          style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
