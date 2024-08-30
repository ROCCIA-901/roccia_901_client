import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/domain/attendance/attendance_detail.dart';
import 'package:untitled/domain/attendance/attendance_request_list.dart';
import 'package:untitled/domain/attendance/user_attendance.dart';
import 'package:untitled/utils/app_logger.dart';

import '../../data/attendance/attendance_repository.dart';
import '../../domain/attendance/attendance_dates.dart';
import '../../domain/attendance/attendance_rate.dart';
import '../authentication/auth_use_case.dart';

part 'attendance_use_cases.g.dart';

@riverpod
Future<AttendanceDates> getAttendanceDatesUseCase(
  GetAttendanceDatesUseCaseRef ref,
) async {
  return await ref.read(attendanceRepositoryProvider).getAttendanceDates();
}

// @riverpod
// Future<AttendanceDates> getAttendanceDatesUseCase(
//   GetAttendanceDatesUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceDatesUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return AttendanceDates(
//     presentDates: [
//       DateTime.parse("2024-08-18"),
//       DateTime.parse("2024-08-13"),
//       DateTime.parse("2024-08-11"),
//     ],
//     lateDates: [
//       DateTime.parse("2024-08-08"),
//       DateTime.parse("2024-08-09"),
//       DateTime.parse("2024-08-03"),
//       DateTime.parse("2024-08-01"),
//       DateTime.parse("2024-09-01"),
//     ],
//   );
// }

@riverpod
Future<AttendanceRate> getAttendanceRateUseCase(
  GetAttendanceRateUseCaseRef ref,
) async {
  logger.d('Execute getAttendanceRateUseCase');
  return await ref.read(attendanceRepositoryProvider).getAttendanceRate();
}

// @riverpod
// Future<AttendanceRate> getAttendanceRateUseCase(
//   GetAttendanceRateUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceRateUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return AttendanceRate(attendanceRate: 80);
// }
// @riverpod
// Future<String> getAttendanceLocationUseCase(
//   GetAttendanceLocationUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceLocationUseCase');
//   return await ref.read(attendanceRepositoryProvider).postRequest();
// }

@riverpod
Future<String> getAttendanceLocationUseCase(
  GetAttendanceLocationUseCaseRef ref,
) async {
  logger.d('Execute getAttendanceLocationUseCase');
  return await ref.read(attendanceRepositoryProvider).getAttendanceLocation();
}

// @riverpod
// Future<String> getAttendanceLocationUseCase(
//   GetAttendanceLocationUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceLocationUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return "더클라임 더미";
// }

@riverpod
Future<void> requestAttendanceUseCase(
  RequestAttendanceUseCaseRef ref,
) async {
  logger.d('Execute requestAttendanceUseCase');
  await ref.read(attendanceRepositoryProvider).postRequest();
  return;
}

// @riverpod
// Future<void> requestAttendanceUseCase(
//   RequestAttendanceUseCaseRef ref,
// ) async {
//   logger.d('Execute requestAttendanceUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return;
// }

@riverpod
Future<AttendanceDetail> getMyAttendanceDetailUseCase(
  GetMyAttendanceDetailUseCaseRef ref,
) async {
  final int userId = await ref.read(getUserIdUseCaseProvider.future);
  return await ref.read(attendanceRepositoryProvider).getAttendanceDetail(userId);
}

@riverpod
Future<AttendanceDetail> getUserAttendanceDetailUseCase(
  GetUserAttendanceDetailUseCaseRef ref,
  int userId,
) async {
  return await ref.read(attendanceRepositoryProvider).getAttendanceDetail(userId);
}

// @riverpod
// Future<AttendanceDetail> getAttendanceDetailUseCase(
//   GetAttendanceDetailUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceDetailUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return AttendanceDetail(
//     count: AttendanceDetailCount(
//       attendance: 15,
//       late: 2,
//       absence: 1,
//       substitute: 0,
//     ),
//     detail: [
//       AttendanceDetailVerbose(
//         week: 1,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 08월 11일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 2,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 08월 18일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 3,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 08월 25일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 4,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 09월 01일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 5,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "대체 출석",
//         date: "2024년 09월 08일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 6,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "지각",
//         date: "2024년 09월 15일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 7,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 09월 22일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 8,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 09월 29일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 9,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "출석",
//         date: "2024년 10월 06일",
//         time: "19:00",
//       ),
//       AttendanceDetailVerbose(
//         week: 10,
//         workoutLocation: Location.theclimbNonhyeon,
//         attendanceStatus: "대체 출석",
//         date: "2024년 10월 13일",
//         time: "19:00",
//       ),
//     ],
//   );
// }

@riverpod
Future<List<AttendanceRequest>> getAttendanceRequestsUseCase(
  GetAttendanceRequestsUseCaseRef ref,
) async {
  logger.d('Execute getAttendanceRequestsUseCase');
  return await ref.read(attendanceRepositoryProvider).getAttendanceRequests();
}

// @riverpod
// Future<List<AttendanceRequest>> getAttendanceRequestsUseCase(
//   GetAttendanceRequestsUseCaseRef ref,
// ) async {
//   logger.d('Execute getAttendanceRequestsUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return [
//     AttendanceRequest(
//       id: 1,
//       requestTime: "2024-08-18 19:00",
//       userId: 1,
//       username: "김철수",
//       generation: "1기",
//       profileNumber: 1,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//     AttendanceRequest(
//       id: 2,
//       requestTime: "2024-08-18 19:00",
//       userId: 2,
//       username: "김영희",
//       generation: "1기",
//       profileNumber: 2,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//     AttendanceRequest(
//       id: 3,
//       requestTime: "2024-08-18 19:00",
//       userId: 3,
//       username: "박철수",
//       generation: "1기",
//       profileNumber: 3,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//     AttendanceRequest(
//       id: 4,
//       requestTime: "2024-08-18 19:00",
//       userId: 4,
//       username: "박영희",
//       generation: "1기",
//       profileNumber: 4,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//     AttendanceRequest(
//       id: 5,
//       requestTime: "2024-08-18 19:00",
//       userId: 5,
//       username: "이철수",
//       generation: "1기",
//       profileNumber: 5,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//     AttendanceRequest(
//       id: 6,
//       requestTime: "2024-08-18 19:00",
//       userId: 6,
//       username: "이영희",
//       generation: "1기",
//       profileNumber: 6,
//       workoutLocation: Location.theclimbNonhyeon,
//       workoutLevel: BoulderLevel.brown,
//     ),
//   ];
// }

@riverpod
Future<void> approveAttendanceRequestUseCase(
  ApproveAttendanceRequestUseCaseRef ref,
  int requestId,
) async {
  logger.d('Execute approveAttendanceRequestUseCase');
  await ref.read(attendanceRepositoryProvider).patchRequestAccept(requestId);
  return;
}

// @riverpod
// Future<void> approveAttendanceRequestUseCase(
//   ApproveAttendanceRequestUseCaseRef ref,
//   int requestId,
// ) async {
//   logger.d('Execute approveAttendanceRequestUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return;
// }

@riverpod
Future<void> rejectAttendanceRequestUseCase(
  RejectAttendanceRequestUseCaseRef ref,
  int requestId,
) async {
  logger.d('Execute rejectAttendanceRequestUseCase');
  await ref.read(attendanceRepositoryProvider).patchRequestReject(requestId);
  return;
}

// @riverpod
// Future<void> rejectAttendanceRequestUseCase(
//   RejectAttendanceRequestUseCaseRef ref,
//   int requestId,
// ) async {
//   logger.d('Execute rejectAttendanceRequestUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return;
// }

@riverpod
Future<List<UserAttendance>> getUserAttendanceListUseCase(
  GetUserAttendanceListUseCaseRef ref,
) async {
  logger.d('Execute getUserAttendanceListUseCase');
  return await ref.read(attendanceRepositoryProvider).getUserAttendances();
}

// @riverpod
// Future<List<UserAttendance>> getUserAttendanceListUseCase(
//   GetUserAttendanceListUseCaseRef ref,
// ) async {
//   logger.d('Execute getUserAttendanceListUseCase');
//   await Future.delayed(Duration(seconds: 2));
//   return [
//     UserAttendance(
//       userId: 1,
//       username: "김철수",
//       generation: "13기",
//       profileNumber: 1,
//       attendanceRate: 80,
//       workoutLocation: "더클라임 메롱",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 2,
//       username: "무하마드",
//       generation: "1기",
//       profileNumber: 2,
//       attendanceRate: 80,
//       workoutLocation: "더클라임 더미",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 3,
//       username: "박수",
//       generation: "1기",
//       profileNumber: 3,
//       attendanceRate: 0,
//       workoutLocation: "더클라임 신림",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 4,
//       username: "박영희",
//       generation: "1기",
//       profileNumber: 11,
//       attendanceRate: 100,
//       workoutLocation: "더클라임 더미",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 1,
//       username: "김철수",
//       generation: "13기",
//       profileNumber: 1,
//       attendanceRate: 80,
//       workoutLocation: "대충 클팍",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 2,
//       username: "무하마드",
//       generation: "1기",
//       profileNumber: 2,
//       attendanceRate: 80,
//       workoutLocation: "대충 클팍",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 3,
//       username: "박수",
//       generation: "1기",
//       profileNumber: 3,
//       attendanceRate: 0,
//       workoutLocation: "대충 클팍",
//       workoutLevel: "브라운",
//     ),
//     UserAttendance(
//       userId: 4,
//       username: "박영희",
//       generation: "1기",
//       profileNumber: 11,
//       attendanceRate: 100,
//       workoutLocation: "대충 클팍",
//       workoutLevel: "브라운",
//     ),
//   ];
// }
