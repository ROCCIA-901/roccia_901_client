import 'dart:async';

// 1. 카운트다운 리셋을 할 수 있어야 한다.
// 1-1. 리셋 시에 기존 타이머를 제거해야 한다.
// 2. 카운트다운 종료 시 콜백을 호출할 수 있다.

/// Countdown을 진행하며 초당 원하는 행동을 합니다.
class CountdownTimer {
  late Timer _timer;
  late int _count;

  /// Countdown할 기간(sec)
  final int duration;

  /// 초당 호출되는 callback
  final void Function() onTick;

  /// Countdown 종료 시 호츌되는 callback
  final void Function() onDone;

  CountdownTimer({
    required this.duration,
    required this.onTick,
    required this.onDone,
  });

  /// start Countdown.
  void start() {
    _count = duration;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        _count--;
        onTick();
        if (_count == 0) {
          timer.cancel();
          onDone();
        }
      },
    );
  }

  /// restart Countdown.
  /// Should call start() before this.
  void restart() {
    _timer.cancel();
    start();
  }

  /// Cancel Countdown.
  /// If you want start Countdown again,
  /// call start().
  void cancel() {
    _timer.cancel();
  }
}
