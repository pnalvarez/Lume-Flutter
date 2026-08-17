import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Headlines', type: _TypographyCatalog)
Widget typoHeadlines(BuildContext context) =>
    const _TypographyCatalog(group: 'Headlines');

@widgetbook.UseCase(name: 'Body', type: _TypographyCatalog)
Widget typoBody(BuildContext context) => const _TypographyCatalog(group: 'Body');

@widgetbook.UseCase(name: 'Labels & Tags', type: _TypographyCatalog)
Widget typoLabels(BuildContext context) =>
    const _TypographyCatalog(group: 'Labels & Tags');

// ---------------------------------------------------------------------------

class _TypographyCatalog extends StatelessWidget {
  final String group;
  const _TypographyCatalog({required this.group});

  @override
  Widget build(BuildContext context) {
    final rows = switch (group) {
      'Body' => _bodyRows,
      'Labels & Tags' => _labelRows,
      _ => _headlineRows,
    };

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: rows
            .map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.$1, style: r.$2),
                    const SizedBox(height: 2),
                    Text(
                      '${r.$1} — ${r.$2.fontSize?.toStringAsFixed(0) ?? '?'}px / w${r.$2.fontWeight?.value ?? '?'}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const Divider(height: 16),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static final _headlineRows = [
    ('headlineXl — The quick brown fox', typ.headlineXl),
    ('headlineL — The quick brown fox', typ.headlineL),
    ('headlineM — The quick brown fox', typ.headlineM),
    ('headlineS — The quick brown fox', typ.headlineS),
    ('headlineXs — The quick brown fox', typ.headlineXs),
    ('headline2xs — The quick brown fox', typ.headline2xs),
    ('subtitleXl — The quick brown fox', typ.subtitleXl),
    ('subtitleL — The quick brown fox', typ.subtitleL),
    ('subtitleM — The quick brown fox', typ.subtitleM),
    ('subtitleS — The quick brown fox', typ.subtitleS),
    ('subtitleXs — The quick brown fox', typ.subtitleXs),
    ('subtitle2xs — The quick brown fox', typ.subtitle2xs),
  ];

  static final _bodyRows = [
    ('body1Light — Lorem ipsum dolor sit amet', typ.body1Light),
    ('body2Light — Lorem ipsum dolor sit amet', typ.body2Light),
    ('body3Light — Lorem ipsum dolor sit amet', typ.body3Light),
    ('body4Light — Lorem ipsum dolor sit amet', typ.body4Light),
    ('body5Light — Lorem ipsum dolor sit amet', typ.body5Light),
    ('body6Light — Lorem ipsum dolor sit amet', typ.body6Light),
    ('body1Medium — Lorem ipsum dolor sit amet', typ.body1Medium),
    ('body2Medium — Lorem ipsum dolor sit amet', typ.body2Medium),
    ('body3Medium — Lorem ipsum dolor sit amet', typ.body3Medium),
    ('body4Medium — Lorem ipsum dolor sit amet', typ.body4Medium),
    ('body1Semibold — Lorem ipsum dolor sit amet', typ.body1Semibold),
    ('body2Semibold — Lorem ipsum dolor sit amet', typ.body2Semibold),
    ('body3Semibold — Lorem ipsum dolor sit amet', typ.body3Semibold),
    ('body4Semibold — Lorem ipsum dolor sit amet', typ.body4Semibold),
  ];

  static final _labelRows = [
    ('labelL — Label Large', typ.labelL),
    ('labelM — Label Medium', typ.labelM),
    ('labelS — Label Small', typ.labelS),
    ('tagRegular — Tag Regular', typ.tagRegular),
    ('tagS — Tag Small', typ.tagS),
    ('tagXS — Tag XSmall', typ.tagXS),
  ];
}
