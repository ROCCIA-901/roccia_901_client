import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/viewmodels/shared/notification_exception.dart';
import 'package:untitled/utils/toast_helper.dart';

import '../../../utils/app_router.dart';

void exceptionHandlerOnView(
  BuildContext context, {
  required Exception e,
  required StackTrace stackTrace,
}) {
  switch (e) {
    case NotificationException():
      _handleNotificationException(
        context,
        e: e,
      );
      break;
    default:
      ToastHelper.showErrorOccurred(context);
      break;
  }
}

void _handleNotificationException(
  BuildContext context, {
  required NotificationException e,
  StackTrace? stackTrace,
}) {
  switch (e.type) {
    case (NotificationType.info):
      ToastHelper.show(context, e.message);
      break;

    case (NotificationType.warning):

      /// Todo: 로그인 요청 메시지 띄우기
      if (e.domain == NotificationDomain.auth) {
        AutoRouter.of(context).push(
          LoginRoute(
            onResult: (BuildContext context, bool result) {
              if (result == true) {
                AutoRouter.of(context).maybePop();
              }
            },
          ),
        );
      } else {
        ToastHelper.show(context, e.message);
      }
      break;

    case (NotificationType.error):
      ToastHelper.showErrorOccurred(context);
      break;
  }
}
