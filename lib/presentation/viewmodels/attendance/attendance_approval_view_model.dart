import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:untitled/domain/attendance/attendance_request_list.dart';

import '../../../application/attendance/attendance_use_cases.dart';
import '../shared/exception_handler_on_viewmodel.dart';

enum AttendanceApprovalEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

class AttendanceApprovalViewModel extends ViewModel<AttendanceApprovalEvent> {
  final Ref _ref;

  AttendanceApprovalViewModel(this._ref) {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e) => _errorHandler(e, e.stackTrace))
        .whenComplete(() {});
  }

  List<AttendanceRequest> _attendanceRequests = [];
  List<AttendanceRequest> get attendanceRequests => _attendanceRequests;

  Future<void> _init() async {
    _attendanceRequests = await _ref.refresh(getAttendanceRequestsUseCaseProvider.future);
  }

  void refresh() {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e) => _errorHandler(e, e.stackTrace))
        .whenComplete(() {});
  }

  void approveAttendanceRequest(int id) {
    emitEvent(AttendanceApprovalEvent.showLoading);
    _ref
        .read(approveAttendanceRequestUseCaseProvider.call(id).future)
        .then((_) async {
          showSnackbar("출석을 승인했습니다.", AttendanceApprovalEvent.showSnackbar);
          _removeLocalAttendanceRequest(id);
          _attendanceRequests = await _ref.refresh(getAttendanceRequestsUseCaseProvider.future);
          updateUi(() {});
        })
        .catchError((e) => _errorHandler(e, e.stackTrace))
        .whenComplete(() {
          emitEvent(AttendanceApprovalEvent.hideLoading);
        });
  }

  void rejectAttendanceRequest(int id) {
    emitEvent(AttendanceApprovalEvent.showLoading);
    _ref
        .read(rejectAttendanceRequestUseCaseProvider.call(id).future)
        .then((_) async {
          showSnackbar("출석을 거절했습니다.", AttendanceApprovalEvent.showSnackbar);
          _removeLocalAttendanceRequest(id);
          _attendanceRequests = await _ref.refresh(getAttendanceRequestsUseCaseProvider.future);
          updateUi(() {});
        })
        .catchError((e) => _errorHandler(e, e.stackTrace))
        .whenComplete(() {
          emitEvent(AttendanceApprovalEvent.hideLoading);
        });
  }

  void _removeLocalAttendanceRequest(int id) {
    _attendanceRequests.removeWhere((element) => element.id == id);
  }

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(AttendanceApprovalEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        AttendanceApprovalEvent.showSnackbar,
      ),
    );
  }
}

final attendanceApprovalViewModelProvider = ViewModelProviderFactory.create((ref) {
  return AttendanceApprovalViewModel(ref);
});
