import 'package:untitled/constants/app_enum.dart';

class UserInfoState {
  /// Profile
  final String name;
  final String generation;
  final UserRole role;
  final Location location;
  final BoulderLevel level;
  final String profileImageUrl;
  final String introduction;

  /// Attendance
  final int presentCount;
  final int absentCount;
  final int lateCount;

  /// Record
  final List<({BoulderLevel level, int count})> boulderProblems;

  const UserInfoState({
    required this.name,
    required this.generation,
    required this.role,
    required this.location,
    required this.level,
    required this.profileImageUrl,
    required this.introduction,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.boulderProblems,
  });
}
