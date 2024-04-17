import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/application/authentication/auth_use_case.dart';

import '../../../domain/authenticatioin/register_form.dart';
import '../../../utils/app_logger.dart';

part 'register_viewmodel.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<void> build() {
    logger.d('Execute RegisterController.build');
  }

  Future<void> execute({
    required String email,
    required String password,
    required String passwordConfirm,
    required String username,
    required String generation,
    required String role,
    required String workoutLocation,
    required String workoutLevel,
    required int profileNumber,
    required String introduction,
  }) async {
    logger.d('Execute RegisterController.execute');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.refresh(
          registerUseCaseProvider(
            form: RegisterForm(
              email: email,
              password: password,
              passwordConfirmation: passwordConfirm,
              username: username,
              generation: generation,
              role: role,
              workoutLocation: workoutLocation,
              workoutLevel: workoutLevel,
              profileNumber: profileNumber,
              introduction: introduction,
            ),
          ).future,
        );
      },
    );
  }
}

@riverpod
class RequestRegisterAuthCodeController
    extends _$RequestRegisterAuthCodeController {
  @override
  FutureOr<void> build() {
    logger.d('Execute RequestRegisterAuthCodeController.build');
  }

  Future<void> execute({
    required String email,
  }) async {
    logger.d('Execute RequestRegisterAuthCodeController.execute');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.refresh(
          requestRegisterAuthCodeUseCaseProvider(
            email: email,
          ).future,
        );
      },
    );
  }
}

@riverpod
class VerifyRegisterAuthCodeController
    extends _$VerifyRegisterAuthCodeController {
  @override
  FutureOr<void> build() {
    logger.d('Execute VerifyRegisterAuthCodeController.build');
  }

  Future<void> execute({
    required String email,
    required String authCode,
  }) async {
    logger.d('Execute VerifyRegisterAuthCodeController.execute');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.refresh(
          verifyRegisterAuthCodeUseCaseProvider(
            email: email,
            authCode: authCode,
          ).future,
        );
      },
    );
  }
}
