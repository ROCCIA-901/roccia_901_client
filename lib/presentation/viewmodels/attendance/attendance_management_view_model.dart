import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:untitled/application/attendance/attendance_use_cases.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/domain/attendance/user_attendance.dart';

import '../shared/exception_handler_on_viewmodel.dart';

enum AttendanceManagementEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

class AttendanceManagementViewModel extends ViewModel<AttendanceManagementEvent> {
  final Ref _ref;

  AttendanceManagementViewModel(this._ref) {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  /// { "{workoutLocation}": List<UserAttendance> }
  Map<String, List<UserAttendance>>? _users;
  Map<String, List<UserAttendance>>? get users => _users;

  Future<void> _init() async {
    _users = _userListToMap(await _ref.refresh(getUserAttendanceListUseCaseProvider.future));
  }

  void refresh() {
    _init()
        .then((_) {
          updateUi(() {});
        })
        .catchError((e, stackTrace) => _errorHandler(e, stackTrace))
        .whenComplete(() {});
  }

  Map<String, List<UserAttendance>> _userListToMap(List<UserAttendance> usersRawData) {
    final Map<String, List<UserAttendance>> result = {};
    List<UserAttendance> oldUsers = [];
    for (var user in usersRawData) {
      if (int.parse(user.generation.replaceAll(RegExp(r'[^0-9]'), '')) < AppConstants.maxGeneration - 1) {
        oldUsers.add(user);
      } else if (result.containsKey(user.workoutLocation)) {
        result[user.workoutLocation]!.add(user);
      } else {
        result[user.workoutLocation] = [user];
      }
    }
    if (oldUsers.isNotEmpty) {
      result['OB'] = oldUsers;
    }
    return result;
  }

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(AttendanceManagementEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        AttendanceManagementEvent.showSnackbar,
      ),
    );
  }
}

final attendanceManagementViewModelProvider = ViewModelProviderFactory.create((ref) {
  return AttendanceManagementViewModel(ref);
});
