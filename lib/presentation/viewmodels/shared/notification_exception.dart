enum NotificationType { error, warning, info }

enum NotificationDomain { auth, none }

/// ViewModel에서 에러 발생 시에 Screen에 표시할 메시지를 전달할 Exception
class NotificationException implements Exception {
  final NotificationType type;
  final NotificationDomain domain;
  final String message;

  NotificationException(
    this.message, {
    this.type = NotificationType.info,
    this.domain = NotificationDomain.none,
  });

  @override
  String toString() {
    return message;
  }
}
