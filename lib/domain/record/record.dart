import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/constants/app_enum.dart';

import '../../utils/app_logger.dart';
import 'boulder_problem.dart';

part 'record.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class RecordModel {
  final int id;
  final int userId;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;
  final List<BoulderProblem> boulderProblems;

  const RecordModel({
    required this.id,
    required this.userId,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.boulderProblems,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RecordModelFromJson(json);
    } on CheckedFromJsonException catch (e) {
      logger.w('Record.fromJson: $e');
      rethrow;
    }
  }
}
