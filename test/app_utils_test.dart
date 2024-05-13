import 'package:test/test.dart';
import 'package:untitled/utils/app_utils.dart';

void main() {
  test("weekNumber test", () {
    final List<(DateTime date, int weekNumber)> correctResults = [
      (DateTime(2024, 1, 1), 1),
      (DateTime(2024, 1, 2), 1),
      (DateTime(2024, 1, 3), 1),
      (DateTime(2024, 1, 4), 1),
      (DateTime(2024, 1, 5), 1),
      (DateTime(2024, 1, 6), 1),
      (DateTime(2024, 1, 7), 1),
      (DateTime(2024, 1, 8), 2),
      (DateTime(2024, 5, 13), 20),
      (DateTime(2024, 12, 31), 53),
      (DateTime(2025, 1, 1), 1),
    ];

    for (final correctResult in correctResults) {
      expect(AppUtils.weekNumber(correctResult.$1), correctResult.$2);
    }
  });
}
