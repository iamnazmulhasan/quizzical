import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quiz Result Logic Tests', () {
    int calculatePercentage(int score, int total) {
      if (total <= 0) return 0;
      return ((score / total) * 100).round();
    }

    String getHeadline(int percent) {
      if (percent >= 60) return "Congratulation";
      return "Keep Trying!";
    }

    test('Score percentage calculation works correctly', () {
      expect(calculatePercentage(8, 10), 80);
      expect(calculatePercentage(1, 3), 33);
      expect(calculatePercentage(10, 10), 100);
      expect(calculatePercentage(0, 10), 0);
    });

    test('High score gives Congratulation headline matching Figma', () {
      expect(getHeadline(80), "Congratulation");
      expect(getHeadline(60), "Congratulation");
    });

    test('Low score gives Keep Trying! headline matching Figma', () {
      expect(getHeadline(33), "Keep Trying!");
      expect(getHeadline(59), "Keep Trying!");
      expect(getHeadline(0), "Keep Trying!");
    });
  });
}
