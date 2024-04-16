import 'package:json_annotation/json_annotation.dart';

import '../../utils/app_logger.dart';

part 'user.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class User {
  final String email;
  final String username;
  final String generation;
  final String role;
  final String workoutLocation;
  final String workoutLevel;
  final int profileNumber;
  final String introduction;

  const User({
    required this.email,
    required this.username,
    required this.generation,
    required this.role,
    required this.workoutLocation,
    required this.workoutLevel,
    required this.profileNumber,
    required this.introduction,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserFromJson(json["user"]);
    } on CheckedFromJsonException catch (e) {
      logger.w('User.fromJson: $e');
      rethrow;
    }
  }
}
