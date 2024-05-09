import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/utils/app_logger.dart';

import '../../../application/authentication/auth_use_case.dart';

part 'logout_viewmodel.g.dart';

@riverpod
class LogOutController extends _$LogOutController {
  @override
  FutureOr<void> build() async {}

  Future<void> execute() async {
    logger.d('Execute LogOutController.execute');
    await AsyncValue.guard(
      () async {
        try {
          await ref.refresh(
            logoutUseCaseProvider.future,
          );
        } catch (e, stackTrace) {
          // exceptionHandlerOnViewmodel(
          //     e: e as Exception, stackTrace: stackTrace);
          return;
        }
      },
    );
  }
}
