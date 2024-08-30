import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:untitled/application/attendance/attendance_use_cases.dart';

import '../shared/exception_handler_on_viewmodel.dart';

enum AttendanceRequestEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

class AttendanceRequestViewModel extends ViewModel<AttendanceRequestEvent> {
  final Ref _ref;

  AttendanceRequestViewModel(this._ref) {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  String _location = "";
  String get location => _location;

  double _attendanceRate = 0.0;
  double get attendanceRate => _attendanceRate;

  Future<void> _init() async {
    _attendanceRate = (await _ref.refresh(getAttendanceRateUseCaseProvider.future)).attendanceRate.toDouble();
    _location = await _ref.refresh(getAttendanceLocationUseCaseProvider.future);
  }

  void refresh() {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  void requestAttendance() {
    emitEvent(AttendanceRequestEvent.showLoading);
    _ref.read(requestAttendanceUseCaseProvider.future).then((value) {
      showSnackbar("출석 요청을 보냈습니다.", AttendanceRequestEvent.showSnackbar);
    }).catchError((e) {
      _errorHandler(e, StackTrace.current);
    }).whenComplete(() {
      emitEvent(AttendanceRequestEvent.hideLoading);
    });
  }

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(AttendanceRequestEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        AttendanceRequestEvent.showSnackbar,
      ),
    );
  }
}

final attendanceRequestViewModelProvider = ViewModelProviderFactory.create((ref) {
  return AttendanceRequestViewModel(ref);
});
