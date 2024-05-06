import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  }) async {
    try {
      headers = _addContentTypeHeader(headers);
      final response = await _http.put(
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
  }) async {
    try {
      final response = await _http.delete(
        path,
        headers: headers,
        encoding: utf8,
      );
      return _processResponse(response);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
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
  final TokenRepository _tokenRepo;

  RocciaApiAuthInterceptor(this._tokenRepo);

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    request.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${await _tokenRepo.accessToken}";
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
    logger.i('Roccia Api Request: ${request.method} ${request.url}');
    if (request is Request && request.body != "") {
      logger.d('Roccia Api Request Body: ${request.body}');
    }
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
            'Roccia Api Response: ${response.request?.url ?? ""} ${response.statusCode}: ${body["detail"] ?? ''}');
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

  static Future? isRefreshing;

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
      await refreshTokenMutualExclusion();
      return true;
    }
    return false;
  }

  Future<void> refreshTokenMutualExclusion() async {
    if (isRefreshing == null) {
      isRefreshing = _refreshToken();
    } else {
      await isRefreshing?.whenComplete(() {
        isRefreshing = null;
      });
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _tokenRepo.refreshToken;
    if (refreshToken == null) {
      throw ApiRefreshTokenExpiredException();
    }
    final uri = _api.auth.refreshToken();
    final requestBody =
        _api.auth.refreshTokenRequestBody(refreshToken: refreshToken);
    // Pure dart http
    final response = await http.post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(requestBody),
      encoding: utf8,
    );
    logger.i('Roccia Api Request: ${uri.toString()}');
    logger.d('Roccia Api Request Body: $requestBody');
    late final Map<String, dynamic> body;
    try {
      body =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      throw ApiUnkownException();
    }
    switch (response.statusCode) {
      case HttpStatus.ok:
        final accessToken = body["data"]["token"]["access"];
        if (accessToken == null) {
          logger.e("Access token is null");
          throw ApiUnkownException();
        }
        await _tokenRepo.saveAccessToken(accessToken);
        break;

      case HttpStatus.badRequest:

        /// Todo: Api 문서와 맞지 않음
        throw ApiRefreshTokenExpiredException();
      // throw ApiException(
      //   statusCode: response.statusCode,
      //   message: body["detail"],
      // );

      case HttpStatus.unauthorized:
        throw ApiRefreshTokenExpiredException();

      default:
        throw ApiUnkownException();
    }
    logger.i(body["detail"]);
  }
}
