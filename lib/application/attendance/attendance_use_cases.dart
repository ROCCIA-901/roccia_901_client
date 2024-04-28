
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/utils/app_logger.dart';

import '../../domain/attendance/attendance_dates.dart';

part 'attendance_use_cases.g.dart';

// @riverpod
// Future<AttendanceDates> getAttendanceDatesUseCase(
//   GetAttendanceDatesUseCaseRef ref,
// ) async {
//   // Todo: Implement userId
//   int userId = 0;
//   logger.d('Execute getAttendanceDatesUseCase');
//   return await ref
//       .read(attendanceRepositoryProvider)
//       .getAttendanceDates(userId);
// }

@riverpod
Future<AttendanceDates> getAttendanceDatesUseCase(
  GetAttendanceDatesUseCaseRef ref,
) async {
  logger.d('Execute getAttendanceDatesUseCase');
  await Future.delayed(Duration(seconds: 2));
  return AttendanceDates(
    presentDates: [
      DateTime.parse("2024-04-18"),
      DateTime.parse("2024-04-13"),
      DateTime.parse("2024-04-11"),
    ],
    lateDates: [
      DateTime.parse("2024-04-08"),
      DateTime.parse("2024-04-09"),
      DateTime.parse("2024-04-03"),
      DateTime.parse("2024-04-01"),
      DateTime.parse("2024-03-01"),
    ],
  );
}
