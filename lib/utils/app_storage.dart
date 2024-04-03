import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage get appStorage => SecureStorage.instance;

class SecureStorage extends FlutterSecureStorage {
  SecureStorage._() : super();

  static final instance = SecureStorage._();
}
