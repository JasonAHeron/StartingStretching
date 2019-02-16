import 'package:flutter_test/flutter_test.dart';

import 'package:lift/timer.dart';

void main() {
  test('duration is formatted correctly', () {
    const testCases = [
      [Duration(minutes: 1), "1:00"],
      [Duration(minutes: 1, seconds: 15), "1:15"],
      [Duration(minutes: 1, seconds: 30), "1:30"],
      [Duration(minutes: 2), "2:00"],
      [Duration(minutes: 3, seconds: 44), "3:44"],
    ];

    testCases.forEach((testCase) {
      expect(RestTimer.timeString(testCase[0]), testCase[1]);
    });
  });
}
