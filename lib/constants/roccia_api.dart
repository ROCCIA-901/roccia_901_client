import 'package:flutter_dotenv/flutter_dotenv.dart';

class RocciaApi {
  static final String _scheme = dotenv.get('ROCCIA_API_SCHEME');
  static final String _baseUrl = dotenv.get('ROCCIA_API_BASE_URL');
  static final int _port = int.parse(dotenv.get('ROCCIA_API_PORT'));

  late final RocciaApiAuthentication auth;
  late final RocciaApiAttendance attendance;
  late final RocciaApiRecord record;
  late final RocciaApiRanking ranking;
  late final RocciaApiUser user;

  RocciaApi() {
    auth = RocciaApiAuthentication(_buildUri);
    attendance = RocciaApiAttendance(_buildUri);
    record = RocciaApiRecord(_buildUri);
    ranking = RocciaApiRanking(_buildUri);
    user = RocciaApiUser(_buildUri);
  }

  Uri _buildUri({required String path, Map<String, String>? queryParameters}) {
    return Uri(
      scheme: _scheme,
      host: _baseUrl,
      path: path,
      port: _port,
      queryParameters: queryParameters,
    );
  }
}

class RocciaApiAuthentication {
  final Uri Function({
    required String path,
    Map<String, String>? queryParameters,
  }) _buildUri;

  RocciaApiAuthentication(this._buildUri);

  Uri login() {
    return _buildUri(path: '/api/accounts/login/');
  }

  Map<String, dynamic> loginRequestBody({
    required String email,
    required String password,
  }) {
    return {
      'email': email,
      'password': password,
    };
  }

  Uri logout() {
    return _buildUri(path: '/api/accounts/logout/');
  }

  Uri register() {
    return _buildUri(path: '/api/accounts/register/');
  }

  Uri getRegisterAuthCode() {
    return _buildUri(path: 'api/accounts/user-register-auth-code-request/');
  }

  Map<String, dynamic> getRegisterAuthCodeRequestBody({
    required String email,
  }) {
    return {
      'email': email,
    };
  }

  Uri verifyRegisterAuthCode() {
    return _buildUri(path: 'api/accounts/user-register-auth-code-verify/');
  }

  Map<String, dynamic> verifyRegisterAuthCodeRequestBody({
    required String email,
    required String authCode,
  }) {
    return {
      'email': email,
      'code': authCode,
    };
  }

  Uri getPasswordUpdateAuthCode() {
    return _buildUri(path: 'api/accounts/password-update-auth-code-request/');
  }

  Map<String, dynamic> getPasswordUpdateAuthCodeRequestBody({
    required String email,
  }) {
    return {
      'email': email,
    };
  }

  Uri verifyPasswordUpdateAuthCode() {
    return _buildUri(path: 'api/accounts/password-update-auth-code-verify/');
  }

  Map<String, dynamic> verifyPasswordUpdateAuthCodeRequestBody({
    required String email,
    required String authCode,
  }) {
    return {
      'email': email,
      'code': authCode,
    };
  }

  Uri updatePassword() {
    return _buildUri(path: 'api/accounts/password-update/');
  }

  Map<String, dynamic> updatePasswordRequestBody({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return {
      'email': email,
      'new_password': password,
      'new_password_confirmation': passwordConfirmation,
    };
  }

  Uri refreshToken() {
    return _buildUri(path: '/api/accounts/token-refresh/');
  }

  Map<String, dynamic> refreshTokenRequestBody({
    required String refreshToken,
  }) {
    return {
      'refresh': refreshToken,
    };
  }
}

class RocciaApiAttendance {
  final Uri Function({
    required String path,
    Map<String, String>? queryParameters,
  }) _buildUri;

  RocciaApiAttendance(this._buildUri);

  Uri dates(int id) {
    return _buildUri(path: 'api/attendances/users/$id/');
  }

  Uri rate() {
    return _buildUri(path: 'api/attendances/rate/');
  }

  Uri request() {
    return _buildUri(path: 'api/attendances/');
  }

  Uri detail(int id) {
    return _buildUri(path: 'api/attendances/users/$id/details/');
  }

  Uri requests() {
    return _buildUri(path: 'api/attendances/requests/');
  }

  Uri requestAccept(int requestId) {
    return _buildUri(path: 'api/attendances/requests/$requestId/accept/');
  }

  Uri requestReject(int requestId) {
    return _buildUri(path: 'api/attendances/requests/$requestId/reject/');
  }

  Uri users() {
    return _buildUri(path: 'api/attendances/users/');
  }
}

class RocciaApiRecord {
  final Uri Function({
    required String path,
    Map<String, String>? queryParameters,
  }) _buildUri;

  RocciaApiRecord(this._buildUri);

  Uri list() {
    return _buildUri(path: 'api/records/');
  }

  Uri create() {
    return _buildUri(path: 'api/records/');
  }

  Uri update(int id) {
    return _buildUri(path: 'api/records/$id/');
  }

  Uri delete(int id) {
    return _buildUri(path: 'api/records/$id/');
  }

  Uri dates() {
    return _buildUri(path: 'api/records/dates/');
  }
}

class RocciaApiRanking {
  final Uri Function({
    required String path,
    Map<String, String>? queryParameters,
  }) _buildUri;

  RocciaApiRanking(this._buildUri);

  Uri weekly() {
    return _buildUri(path: 'api/rankings/weeks/');
  }

  Uri generations() {
    return _buildUri(path: 'api/rankings/generations/');
  }
}

class RocciaApiUser {
  final Uri Function({
    required String path,
    Map<String, String>? queryParameters,
  }) _buildUri;

  RocciaApiUser(this._buildUri);

  Uri profile() {
    return _buildUri(path: 'api/mypages/');
  }

  Uri otherProfile(int id) {
    return _buildUri(path: 'api/mypages/', queryParameters: {'user_id': id.toString()});
  }
}
