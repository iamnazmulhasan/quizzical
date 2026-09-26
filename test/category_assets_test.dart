import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Category Assets Verification', () {
    final expectedCategories = [
      'General Knowledge',
      'Entertainment: Books',
      'Entertainment: Film',
      'Entertainment: Music',
      'Entertainment: Musicals & Theatres',
      'Entertainment: Television',
      'Entertainment: Video Games',
      'Entertainment: Board Games',
      'Science & Nature',
      'Science: Computers',
      'Science: Mathematics',
      'Mythology',
      'Sports',
      'Geography',
      'History',
      'Politics',
      'Art',
      'Celebrities',
      'Animals',
      'Vehicles',
      'Entertainment: Comics',
      'Science: Gadgets',
      'Entertainment: Japanese Anime & Manga',
      'Entertainment: Cartoon & Animations',
    ];

    String assetForCategory(String name) {
      final key = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
      return 'assets/images/categories/$key.png';
    }

    test('Every OpenTDB category maps to an existing pictorial PNG asset', () {
      for (final catName in expectedCategories) {
        final path = assetForCategory(catName);
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: 'Missing asset for category "$catName" at path $path');
        expect(file.lengthSync(), greaterThan(1000), reason: 'Asset $path is too small or empty');
      }
    });

    test('Previously missing categories from History onwards now have pictorial icons', () {
      final fromHistory = [
        'History',
        'Politics',
        'Art',
        'Celebrities',
        'Animals',
        'Vehicles',
        'Entertainment: Comics',
        'Science: Gadgets',
        'Entertainment: Japanese Anime & Manga',
        'Entertainment: Cartoon & Animations',
      ];

      for (final cat in fromHistory) {
        final file = File(assetForCategory(cat));
        expect(file.existsSync(), isTrue);
        expect(file.lengthSync(), greaterThan(5000));
      }
    });
  });
}
