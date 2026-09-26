import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/features/categories/domain/models/category_model.dart';
import 'package:quizzical/features/quiz/domain/models/quiz_model.dart';

void main() {
  group('CategoryModel Tests', () {
    test('fromJson parses correctly', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final cat = CategoryModel.fromJson(json);

      expect(cat.id, 9);
      expect(cat.name, 'General Knowledge');
    });

    test('toJson generates expected map', () {
      final cat = CategoryModel(id: 10, name: 'Entertainment: Books');
      final map = cat.toJson();

      expect(map['id'], 10);
      expect(map['name'], 'Entertainment: Books');
    });
  });

  group('QuestionModel Tests', () {
    test('fromJson decodes Base64 correctly', () {
      final questionB64 = base64.encode(utf8.encode('What is 2 + 2?'));
      final correctB64 = base64.encode(utf8.encode('4'));
      final inc1B64 = base64.encode(utf8.encode('3'));
      final inc2B64 = base64.encode(utf8.encode('5'));
      final inc3B64 = base64.encode(utf8.encode('6'));

      final json = {
        'type': base64.encode(utf8.encode('multiple')),
        'difficulty': base64.encode(utf8.encode('easy')),
        'category': base64.encode(utf8.encode('Science: Mathematics')),
        'question': questionB64,
        'correct_answer': correctB64,
        'incorrect_answers': [inc1B64, inc2B64, inc3B64],
      };

      final q = QuestionModel.fromJson(json);

      expect(q.question, 'What is 2 + 2?');
      expect(q.correctAnswer, '4');
      expect(q.incorrectAnswers, ['3', '5', '6']);
      expect(q.type, 'multiple');
      expect(q.difficulty, 'easy');
      expect(q.category, 'Science: Mathematics');
    });

    test('fromJson decodes HTML entities when raw text is passed', () {
      final json = {
        'type': 'multiple',
        'difficulty': 'medium',
        'category': 'General Knowledge',
        'question': 'Which &quot;quote&quot; is correct&#039;s answer &amp; test?',
        'correct_answer': 'Tom &amp; Jerry',
        'incorrect_answers': ['Mickey &amp; Donald', 'Ben &amp; Jerry'],
      };

      final q = QuestionModel.fromJson(json);

      expect(q.question, 'Which "quote" is correct\'s answer & test?');
      expect(q.correctAnswer, 'Tom & Jerry');
      expect(q.incorrectAnswers, ['Mickey & Donald', 'Ben & Jerry']);
    });
  });
}
