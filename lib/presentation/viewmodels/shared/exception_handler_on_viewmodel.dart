import 'package:untitled/data/shared/api_exception.dart';

import '../../../utils/app_logger.dart';
import 'notification_exception.dart';

void appExceptionHandlerOnViewmodel({
  required Exception e,
  required StackTrace stackTrace,
  required void Function() emitGoToLoginScreenEvent,
  required void Function(String message) emitShowSnackbarEvent,
}) {
  switch (e) {
    case ApiRefreshTokenExpiredException():
      emitShowSnackbarEvent("세션이 만료되었습니다. 다시 로그인해주세요.");
      emitGoToLoginScreenEvent();
      break;
    case ApiRequestTimeoutException():
      emitShowSnackbarEvent("요청 시간이 초과되었습니다. 인터넷 연결을 확인해주세요.");
      break;
    case ApiUnkownException():
      emitShowSnackbarEvent("알 수 없는 에러가 발생하였습니다. 운영진에게 알려주세요!");
      break;
    case ApiException():
      emitShowSnackbarEvent(e.message);
      break;
    default:
      emitShowSnackbarEvent("알 수 없는 에러가 발생하였습니다. 운영진에게 알려주세요!");
  }
}

void exceptionHandlerOnViewmodel({
  required Exception e,
  required StackTrace stackTrace,
}) {
  switch (e) {
    case ApiException():
      _handleApiException(
        e: e,
      );
      break;
    default:
      logger.e("On View: Unexpected Exception", error: e, stackTrace: stackTrace);
      throw NotificationException(
        "알 수 없는 오류가 발생했습니다. 운영진에게 문의 바랍니다.",
        type: NotificationType.error,
      );
  }
}

void _handleApiException({
  required ApiException e,
  StackTrace? stackTrace,
}) {
  switch (e) {
    case ApiRefreshTokenExpiredException():
      throw NotificationException(
        "세션이 만료되었습니다. 다시 로그인해주세요.",
        type: NotificationType.warning,
        domain: NotificationDomain.auth,
      );
    case ApiRequestTimeoutException():
      throw NotificationException(
        "요청 시간이 초과되었습니다. 인터넷 연결을 확인해주세요.",
        type: NotificationType.warning,
      );
    case ApiUnkownException():
      throw NotificationException(
        "알 수 없는 오류가 발생했습니다. 운영진에게 문의 바랍니다.",
        type: NotificationType.error,
      );
    default:
      throw NotificationException(
        e.message,
        type: NotificationType.info,
      );
  }
}
