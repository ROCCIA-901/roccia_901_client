/// ViewModel에서 에러 발생 시에 Screen에 표시할 메시지를 전달할 Exception
class NotificationException implements Exception {
  final String message;

  NotificationException(this.message);

  @override
  String toString() {
    return message;
  }
}
