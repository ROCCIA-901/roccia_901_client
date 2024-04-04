import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class IAppStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class AppStorage implements IAppStorage {
  final FlutterSecureStorage _storage;

  AppStorage(this._storage);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

final appStorageProvider = Provider<IAppStorage>(
  (ref) => AppStorage(FlutterSecureStorage()),
);
