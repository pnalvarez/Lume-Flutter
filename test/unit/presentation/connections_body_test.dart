import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_body.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

const _game = ConnectionsGameDomain(
  pairId: 1,
  sortOrder: 1,
  title: 'Titulo',
  subtitle: 'Subtitulo',
  leftColumn: [
    ConnectionItemDomain(id: 'l1', text: '1822'),
    ConnectionItemDomain(id: 'l2', text: '1888'),
  ],
  rightColumn: [
    ConnectionItemDomain(id: 'r1', text: 'Independencia'),
    ConnectionItemDomain(id: 'r2', text: 'Abolicao'),
  ],
  pairs: [
    ConnectionPairDomain(leftId: 'l1', rightId: 'r1'),
    ConnectionPairDomain(leftId: 'l2', rightId: 'r2'),
  ],
);

void main() {
  late List<String> lefts;
  late List<String> rights;

  Future<void> pump(WidgetTester tester, ConnectionsState state) async {
    lefts = [];
    rights = [];
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: ConnectionsBody(
            state: state,
            onLeftSelected: lefts.add,
            onRightSelected: rights.add,
            onUndoLast: () {},
            onSubmit: () {},
            onNext: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('dragging a left chip onto a right chip selects then links', (
    tester,
  ) async {
    await pump(tester, const ConnectionsState(game: _game));

    final from = tester.getCenter(find.text('1822'));
    final to = tester.getCenter(find.text('Independencia'));
    final gesture = await tester.startGesture(from);
    await tester.pump();
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(lefts, ['l1']);
    expect(rights, ['r1']);
  });

  testWidgets('dropping outside a right chip links nothing', (tester) async {
    await pump(tester, const ConnectionsState(game: _game));

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('1822')),
    );
    await tester.pump();
    await gesture.moveTo(const Offset(200, 700));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(lefts, ['l1']);
    expect(rights, isEmpty);
  });

  testWidgets('dragging is disabled after answering', (tester) async {
    await pump(
      tester,
      const ConnectionsState(
        game: _game,
        links: {'l1': 'r1', 'l2': 'r2'},
        linkOrder: ['l1', 'l2'],
        answered: true,
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('1822')),
    );
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Abolicao')));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(lefts, isEmpty);
    expect(rights, isEmpty);
  });

  testWidgets('tap-to-link still works as a fallback', (tester) async {
    await pump(
      tester,
      const ConnectionsState(game: _game, selectedLeftId: 'l1'),
    );

    await tester.tap(find.text('Independencia'));
    await tester.pump();

    expect(rights, ['r1']);
  });
}
