import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'token_repository.dart';
import '../shared/api_exception.dart';
import '../../domain/authenticatioin/register_form.dart';
import '../../constants/roccia_api.dart';
import '../../domain/authenticatioin/token.dart';
import '../../utils/app_logger.dart';
import '../shared/roccia_api_client.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    api: RocciaApi(),
    apiClient: RocciaApiClient(interceptors: [RocciaApiLoggerInterceptor()]),
    tokenRepository: ref.watch(tokenRepositoryProvider),
  ),
);

class AuthRepository {
  final RocciaApi _api;
  final RocciaApiClient _apiClient;
  final TokenRepository _tokenRepo;

  AuthRepository({
    required RocciaApi api,
    required RocciaApiClient apiClient,
    required TokenRepository tokenRepository,
  })  : _api = api,
        _apiClient = apiClient,
        _tokenRepo = tokenRepository;

  Future<void> login({required String email, required String password}) async {
    try {
      final uri = _api.auth.login();
      final body = await _apiClient.post(
        uri,
        body: _api.auth.loginRequestBody(email: email, password: password),
      );
      final token = Token.fromJson(body);
      if (token.refresh == null) {
        const message = 'Refresh Token is null';
        throw Exception(message);
      }
      await _tokenRepo.saveTokens(
        accessToken: token.access,
        refreshToken: token.refresh!,
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> logout() async {
    try {
      final uri = _api.auth.logout();
      await _apiClient.post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${await _tokenRepo.accessToken}",
        },
        body: {"refresh": await _tokenRepo.refreshToken},
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> register({required RegisterForm form}) async {
    try {
      final uri = _api.auth.register();
      await _apiClient.post(
        uri,
        body: form.toJson(),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> requestRegisterAuthCode({required String email}) async {
    try {
      final uri = _api.auth.getRegisterAuthCode();
      await _apiClient.post(
        uri,
        body: _api.auth.getRegisterAuthCodeRequestBody(email: email),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> verifyRegisterAuthCode({
    required String email,
    required String authCode,
  }) async {
    try {
      final uri = _api.auth.verifyRegisterAuthCode();
      await _apiClient.post(
        uri,
        body: _api.auth.verifyRegisterAuthCodeRequestBody(
          email: email,
          authCode: authCode,
        ),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> requestPasswordUpdateAuthCode({required String email}) async {
    try {
      final uri = _api.auth.getPasswordUpdateAuthCode();
      await _apiClient.post(
        uri,
        body: _api.auth.getPasswordUpdateAuthCodeRequestBody(email: email),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> verifyPasswordUpdateAuthCode({
    required String email,
    required String authCode,
  }) async {
    try {
      final uri = _api.auth.verifyPasswordUpdateAuthCode();
      await _apiClient.post(
        uri,
        body: _api.auth.verifyPasswordUpdateAuthCodeRequestBody(
          email: email,
          authCode: authCode,
        ),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  Future<void> updatePassword(
      {required String email,
      required String password,
      required String passwordConfirmation}) async {
    try {
      final uri = _api.auth.updatePassword();
      await _apiClient.patch(
        uri,
        body: _api.auth.updatePasswordRequestBody(
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
    }
  }

  void _errorHandler(e, StackTrace stackTrace) {
    try {
      throw e;
    } on ApiException catch (_) {
      rethrow;
    } catch (e) {
      logger.w('On Auth Repo: ${e.toString()}',
          stackTrace: stackTrace, error: e);
      rethrow;
    }
  }
}
