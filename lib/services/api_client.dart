import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:untitled/config/api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String errorCode;
  final String detail;

  ApiException({
    this.statusCode,
    String? errorCode,
    String? detail,
  })  : errorCode = errorCode ?? "Unknown error code",
        detail = detail ?? "An error occurred";

  @override
  String toString() => 'Error ${statusCode ?? ''}: $errorCode: $detail';
}

class ApiRequestTimeoutException extends ApiException {
  ApiRequestTimeoutException()
      : super(
          statusCode: HttpStatus.requestTimeout,
          errorCode: 'Request timed out',
          detail: '연결 시간이 초과되었습니다.',
        );
}

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  final Duration timeoutDuration;

  ApiClient({
    required this.baseUrl,
    int? timeoutSec,
  })  : defaultHeaders = {},
        timeoutDuration = Duration(seconds: timeoutSec ?? ApiConfig.timeout);

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? params,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    try {
      final response = await http
          .get(url, headers: headers ?? defaultHeaders)
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      throw ApiRequestTimeoutException();
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$path');
    try {
      final response = await http
          .post(
            url,
            headers: headers ?? defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      throw ApiRequestTimeoutException();
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$path');
    try {
      final response = await http
          .put(
            url,
            headers: headers ?? defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      throw ApiRequestTimeoutException();
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$path');
    try {
      final response = await http
          .patch(
            url,
            headers: headers ?? defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      throw ApiRequestTimeoutException();
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$path');
    try {
      final response = await http
          .delete(
            url,
            headers: headers ?? defaultHeaders,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      throw ApiRequestTimeoutException();
    }
  }

  /// If the response is successful, body is returned.
  /// Otherwise, it throws an ApiException.
  Map<String, dynamic> _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final Map<String, dynamic> body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (statusCode < 200 || statusCode >= 300) {
      throw ApiException(
        statusCode: statusCode,
        detail: body["detail"],
        errorCode: body["code"],
      );
    }

    return body;
  }
}
