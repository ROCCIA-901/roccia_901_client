import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/constants/app_enum.dart';

import '../../utils/app_logger.dart';

part 'boulder_problem.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class BoulderProblem {
  final BoulderLevel level;
  final int numberOfCompletions;

  const BoulderProblem({
    required this.level,
    required this.numberOfCompletions,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory BoulderProblem.fromJson(Map<String, dynamic> json) {
    try {
      return _$BoulderProblemFromJson(json);
    } on CheckedFromJsonException catch (e) {
      logger.w('BoulderProblem.fromJson: $e');
      rethrow;
    }
  }
}
