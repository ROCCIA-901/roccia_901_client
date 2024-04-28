import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/application/authentication/auth_use_case.dart';
import 'package:untitled/data/shared/api_exception.dart';

import '../shared/notification_exception.dart';
import '../../../utils/app_logger.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    logger.d('Execute LoginController.build');
  }

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    logger.d('Execute LoginController.execute');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        try {
          await ref.refresh(
            loginUseCaseProvider(
              email: email,
              password: password,
            ).future,
          );
        } on ApiException catch (e) {
          throw NotificationException(e.message);
        }
      },
    );
  }
}
