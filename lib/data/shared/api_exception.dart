import 'dart:io';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException({this.statusCode, message})
      : message = message ?? '에러 발생. 운영진에게 문의바랍니다.';

  @override
  String toString() {
    return 'Roccia Api Client Exception: ${statusCode ?? 'Unknown'} Error: $message';
  }
}

class ApiRequestTimeoutException extends ApiException {
  ApiRequestTimeoutException()
      : super(
          statusCode: HttpStatus.requestTimeout,
          message: '응답시간 초과. 인터넷 연결을 확인해주세요.',
        );
}

class ApiRequestInvalidRefreshTokenException extends ApiException {
  ApiRequestInvalidRefreshTokenException()
      : super(
          statusCode: HttpStatus.unauthorized,
          message: 'Refresh Token is invalid',
        );
}
