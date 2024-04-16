import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_logger.dart';
import '../shared/app_storage.dart';

final tokenRepositoryProvider = Provider<TokenRepository>(
  (ref) => TokenRepository(
    appStorage: ref.watch(appStorageProvider),
  ),
);

class TokenRepository {
  final IAppStorage _appStorage;

  TokenRepository({
    required IAppStorage appStorage,
  }) : _appStorage = appStorage;

  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';

  Future<String> get accessToken async {
    final accessToken = await _appStorage.read(key: _accessTokenKey);
    if (accessToken == null) {
      throw Exception('Access Token is null');
    }
    return accessToken;
  }

  Future<String> get refreshToken async {
    final refreshToken = await _appStorage.read(key: _refreshTokenKey);
    if (refreshToken == null) {
      throw Exception('Refresh Token is null');
    }
    return refreshToken;
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _appStorage.write(key: _accessTokenKey, value: accessToken);
    logger.d('Access Token saved');
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _appStorage.write(key: _refreshTokenKey, value: refreshToken);
    logger.d('Refresh Token saved');
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }
}
