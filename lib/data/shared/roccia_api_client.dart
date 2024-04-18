import 'dart:async';
import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/data/shared/api_exception.dart';
import 'package:untitled/utils/app_logger.dart';

import '../../constants/roccia_api.dart';
import '../authentication/token_repository.dart';

class RocciaApiClient {
  final List<InterceptorContract> _interceptors;
  final RetryPolicy? _retryPolicy;
  late final InterceptedHttp _http;

  RocciaApiClient({
    List<InterceptorContract>? interceptors,
    RetryPolicy? retryPolicy,
  })  : _interceptors = interceptors ?? [],
        _retryPolicy = retryPolicy {
    _http = InterceptedHttp.build(
      interceptors: _interceptors,
      retryPolicy: _retryPolicy,
      requestTimeout: Duration(seconds: AppConstants.apiRequestTimeout),
    );
  }

  Future<Map<String, dynamic>> get(
    Uri path, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _http.get(
        path,
        headers: headers,
      );
      return _processResponse(response);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    Uri path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      headers = _addContentTypeHeader(headers);
      final response = await _http.post(
        path,
        headers: headers,
        body: jsonEncode(body),
        encoding: utf8,
      );
      return _processResponse(response);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    Uri path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> patch(
    Uri path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      headers = _addContentTypeHeader(headers);
      final response = await _http.patch(
        path,
        headers: headers,
        body: jsonEncode(body),
        encoding: utf8,
      );
      return _processResponse(response);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(
    Uri path, {
    Map<String, String>? headers,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  /// If the response is successful, body is returned.
  /// Otherwise, it throws an ApiException.
  Map<String, dynamic> _processResponse(Response response) {
    final int statusCode = response.statusCode;
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (statusCode < 200 || statusCode >= 300) {
      throw ApiException(
        statusCode: statusCode,
        message: body["detail"],
      );
    }

    final Map<String, dynamic> data = body["data"] ?? {};
    return data;
  }

  // add content type header
  Map<String, String> _addContentTypeHeader(Map<String, String>? headers) {
    headers ??= {};
    headers["Content-Type"] = "application/json";
    return headers;
  }

  void _errorHandler(e, StackTrace stackTrace) {
    logger.w("On Rccia API Client: ${e.toString()}",
        stackTrace: stackTrace, error: e);
    try {
      throw e;
    } on TimeoutException catch (_) {
      throw ApiRequestTimeoutException();
    }
  }
}

class RocciaApiAuthInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }
}

class RocciaApiLoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    logger.i('Roccia Api Request: ${request.url}');
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    try {
      if (response is Response) {
        final body =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        logger.i(
            'Roccia Api Response: ${response.statusCode}: ${body["detail"] ?? ''}');
      }
    } on FormatException catch (e, stackTrace) {
      logger.w('On Roccia API Client: Body is not JSON format',
          stackTrace: stackTrace);
      throw ApiException(
          statusCode: response.statusCode, message: "에러 발생. 운영진에게 문의바랍니다.");
    } catch (e, stackTrace) {
      logger.w('On Roccia API Client:: Error',
          stackTrace: stackTrace, error: e);
      rethrow;
    }

    return response;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final RocciaApi _api;
  final TokenRepository _tokenRepo;

  ExpiredTokenRetryPolicy(this._api, this._tokenRepo);

  @override
  int get maxRetryAttempts => 2;

  @override
  Future<bool> shouldAttemptRetryOnException(
      Exception reason, BaseRequest request) async {
    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      await _refreshToken();
      return true;
    }
    return false;
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _tokenRepo.refreshToken;
    final uri = _api.auth.refreshToken();
    // Pure dart http
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
          _api.auth.refreshTokenRequestBody(refreshToken: refreshToken)),
      encoding: utf8,
    );
    if (response.statusCode != 200) {
      throw ApiRequestInvalidRefreshTokenException();
    }
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final accessToken = body["data"]["token"]["access"];
    if (accessToken == null) {
      throw ApiException(
        statusCode: response.statusCode,
        message: "Access Token is null",
      );
    }
    await _tokenRepo.saveAccessToken(accessToken);
    logger.i(body["detail"]);
  }
}
