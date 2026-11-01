import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/visual_choice_game_round_mapper.dart';
import 'package:lume/layers/data/models/visual_choice_game_round_data.dart';

void main() {
  test('maps the payload and keeps shuffled option order', () {
    final data = VisualChoiceGameRoundData.fromJson({
      'question_id': 7,
      'prompt_text': 'Who painted this?',
      'image_url': 'https://cdn.example/art.jpg',
      'question_type': 'identify_artist',
      'options': [
        {'text': 'Van Gogh', 'is_correct': false},
        {'text': 'Da Vinci', 'is_correct': true},
        {'text': 'Picasso', 'is_correct': false},
        {'text': 'Monet', 'is_correct': false},
      ],
      'correct_answer': 'Da Vinci',
      'curiosity_fact': 'It hung in a hallway.',
      'feedback_correct': 'That is the painter.',
      'feedback_incorrect': 'Look at the brushwork.',
      'period': 'Renaissance',
    });

    final round = VisualChoiceGameRoundMapper.toDomain(data);

    expect(round.questionId, 7);
    expect(round.prompt, 'Who painted this?');
    expect(round.imageUrl, 'https://cdn.example/art.jpg');
    expect(round.questionType, 'identify_artist');
    expect(round.options, ['Van Gogh', 'Da Vinci', 'Picasso', 'Monet']);
    expect(round.correctAnswer, 'Da Vinci');
    expect(round.curiosity, 'It hung in a hallway.');
    expect(round.feedbackCorrect, 'That is the painter.');
    expect(round.feedbackIncorrect, 'Look at the brushwork.');
  });

  test('drops repeated option labels, keeping the first occurrence', () {
    final data = VisualChoiceGameRoundData.fromJson({
      'question_id': 9,
      'prompt_text': 'Quem é esta pessoa?',
      'image_url': 'https://cdn.example/person.jpg',
      'question_type': 'identify_person',
      'options': [
        {'text': 'Marie Curie', 'is_correct': true},
        {'text': 'Ada Lovelace', 'is_correct': false},
        {'text': 'Marie Curie', 'is_correct': false},
        {'text': 'Ada Lovelace', 'is_correct': false},
        {'text': 'Albert Einstein', 'is_correct': false},
      ],
      'correct_answer': 'Marie Curie',
      'curiosity_fact': null,
      'feedback_correct': null,
      'feedback_incorrect': null,
    });

    final round = VisualChoiceGameRoundMapper.toDomain(data);

    expect(round.options, ['Marie Curie', 'Ada Lovelace', 'Albert Einstein']);
  });

  test('prefers image_override over the artwork image', () {
    final data = VisualChoiceGameRoundData.fromJson({
      'question_id': 8,
      'prompt_text': 'Which movement is this?',
      'image_url': 'https://cdn.example/art.jpg',
      'image_override': 'https://cdn.example/detail.jpg',
      'question_type': 'identify_movement',
      'options': [
        {'text': 'Cubism', 'is_correct': false},
        {'text': 'Baroque', 'is_correct': false},
        {'text': 'Impressionism', 'is_correct': true},
        {'text': 'Pop Art', 'is_correct': false},
      ],
      'correct_answer': 'Impressionism',
      'curiosity_fact': null,
      'feedback_correct': null,
      'feedback_incorrect': null,
    });

    final round = VisualChoiceGameRoundMapper.toDomain(data);

    expect(round.imageUrl, 'https://cdn.example/detail.jpg');
    expect(round.options, ['Cubism', 'Baroque', 'Impressionism', 'Pop Art']);
    expect(round.curiosity, isNull);
  });
}
