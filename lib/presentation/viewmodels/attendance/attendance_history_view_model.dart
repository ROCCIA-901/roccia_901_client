import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:untitled/application/attendance/attendance_use_cases.dart';
import 'package:untitled/domain/attendance/attendance_detail.dart';

import '../shared/exception_handler_on_viewmodel.dart';

enum AttendanceHistoryEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

class AttendanceHistoryViewModel extends ViewModel<AttendanceHistoryEvent> {
  final Ref _ref;

  AttendanceHistoryViewModel(this._ref) {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  AttendanceDetail? _myAttendanceDetails;
  AttendanceDetail? get myAttendanceDetails => _myAttendanceDetails;
  AttendanceDetail? _userAttendanceDetails;
  AttendanceDetail? get userAttendanceDetails => _userAttendanceDetails;

  Future<void> _init() async {
    _myAttendanceDetails = await _ref.refresh(getMyAttendanceDetailUseCaseProvider.future);
  }

  void refresh() {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  void fetchUserAttendanceDetails(int userId) {
    _ref.refresh(getUserAttendanceDetailUseCaseProvider(userId).future).then((value) {
      _userAttendanceDetails = value;
      updateUi(() {});
    }).catchError((e, stackTrace) => _errorHandler(e, stackTrace));
  }

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(AttendanceHistoryEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        AttendanceHistoryEvent.showSnackbar,
      ),
    );
  }
}

final attendanceHistoryViewModelProvider = ViewModelProviderFactory.create((ref) {
  return AttendanceHistoryViewModel(ref);
});
