import 'package:daily_receipt/models/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('calendar Provider', () {
    var calendarProvider = Calendar();

    test('인자로 넘긴 날짜가 selectedDate로 설정됩니다.', () {
      var selectedDate = DateTime(2024, 1, 1);

      calendarProvider.selectDate(selectedDate);

      expect(calendarProvider.selectedDate, selectedDate);
    });
  });
}
