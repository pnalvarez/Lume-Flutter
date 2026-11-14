import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';

const _game = ConnectionsGameDomain(
  pairId: 1,
  sortOrder: 1,
  title: 't',
  subtitle: 's',
  leftColumn: [
    ConnectionItemDomain(id: 'l1', text: 'a'),
    ConnectionItemDomain(id: 'l2', text: 'b'),
    ConnectionItemDomain(id: 'l3', text: 'c'),
    ConnectionItemDomain(id: 'l4', text: 'd'),
  ],
  rightColumn: [
    ConnectionItemDomain(id: 'r1', text: 'A'),
    ConnectionItemDomain(id: 'r2', text: 'B'),
    ConnectionItemDomain(id: 'r3', text: 'C'),
    ConnectionItemDomain(id: 'r4', text: 'D'),
  ],
  pairs: [
    ConnectionPairDomain(leftId: 'l1', rightId: 'r1'),
    ConnectionPairDomain(leftId: 'l2', rightId: 'r2'),
    ConnectionPairDomain(leftId: 'l3', rightId: 'r3'),
    ConnectionPairDomain(leftId: 'l4', rightId: 'r4'),
  ],
);

const _purple = '#C9A0DC';
const _orange = '#F4A261';
const _green = '#A8D5A2';

void main() {
  test('idle items have no pair color', () {
    const state = ConnectionsState(game: _game);
    expect(state.pairHexForLeft('l1'), isNull);
    expect(state.pairHexForRight('r1'), isNull);
  });

  test('selected left item previews the first free color (purple)', () {
    const state = ConnectionsState(game: _game, selectedLeftId: 'l1');
    expect(state.pairHexForLeft('l1'), _purple);
    expect(state.pairHexForRight('r1'), isNull);
  });

  test('linked pair shares one color; next selection previews the next', () {
    const state = ConnectionsState(
      game: _game,
      selectedLeftId: 'l2',
      links: {'l1': 'r1'},
      linkOrder: ['l1'],
    );
    expect(state.pairHexForLeft('l1'), _purple);
    expect(state.pairHexForRight('r1'), _purple);
    expect(state.pairHexForLeft('l2'), _orange);
  });

  test('colors follow pair order: purple, orange, green', () {
    const state = ConnectionsState(
      game: _game,
      links: {'l1': 'r2', 'l2': 'r1', 'l3': 'r3'},
      linkOrder: ['l1', 'l2', 'l3'],
    );
    expect(state.pairHexForLeft('l1'), _purple);
    expect(state.pairHexForRight('r2'), _purple);
    expect(state.pairHexForLeft('l2'), _orange);
    expect(state.pairHexForRight('r1'), _orange);
    expect(state.pairHexForLeft('l3'), _green);
    expect(state.pairHexForRight('r3'), _green);
  });

  test('palette cycles after the third pair', () {
    const state = ConnectionsState(
      game: _game,
      links: {'l1': 'r1', 'l2': 'r2', 'l3': 'r3', 'l4': 'r4'},
      linkOrder: ['l1', 'l2', 'l3', 'l4'],
    );
    expect(state.pairHexForLeft('l4'), _purple);
  });

  test('undoing the last pair frees its color for the next selection', () {
    const linked = ConnectionsState(
      game: _game,
      links: {'l1': 'r1', 'l2': 'r2'},
      linkOrder: ['l1', 'l2'],
    );
    expect(linked.pairHexForLeft('l2'), _orange);

    final undone = linked.copyWith(
      links: {'l1': 'r1'},
      linkOrder: ['l1'],
      selectedLeftId: 'l2',
    );
    expect(undone.pairHexForRight('r2'), isNull);
    expect(undone.pairHexForLeft('l2'), _orange);
  });

  test('answered state returns no pair colors (feedback visuals win)', () {
    const state = ConnectionsState(
      game: _game,
      links: {'l1': 'r1'},
      linkOrder: ['l1'],
      answered: true,
    );
    expect(state.pairHexForLeft('l1'), isNull);
    expect(state.pairHexForRight('r1'), isNull);
  });
}
