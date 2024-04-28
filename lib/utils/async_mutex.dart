import 'dart:async';

/// https://stackoverflow.com/questions/42071051/dart-how-to-manage-concurrency-in-async-function
class AsyncMutex {
  Future _next = Future.value(null);

  /// Request [operation] to be run exclusively.
  ///
  /// Waits for all previously requested operations to complete,
  /// then runs the operation and completes the returned future with the
  /// result.
  Future<T> run<T>(Future<T> Function() operation) {
    var completer = Completer<T>();
    _next.whenComplete(() {
      completer.complete(Future<T>.sync(operation));
    });
    return _next = completer.future;
  }
}
