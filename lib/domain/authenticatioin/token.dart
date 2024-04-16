import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/utils/app_logger.dart';

part 'token.g.dart';

@JsonSerializable(checked: true, includeIfNull: false)
class Token {
  final String access;
  final String? refresh;

  const Token(
    this.access,
    this.refresh,
  );

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory Token.fromJson(Map<String, dynamic> json) {
    try {
      return _$TokenFromJson(json["token"]);
    } on CheckedFromJsonException catch (e) {
      logger.w('Token.fromJson: $e');
      rethrow;
    }
  }
}
