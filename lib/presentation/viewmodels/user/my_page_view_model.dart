import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';

import '../../../application/user/user_use_case.dart';
import '../../../constants/app_enum.dart';
import '../../../domain/user/profile.dart';
import '../shared/exception_handler_on_viewmodel.dart';

enum MyPageEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

typedef MyPageTableContents = List<({String field, String value})>;

class MyPageState {
  /// TODO: 중복되는 데이터 정리
  final String profileImage;
  final String introduction;
  final MyPageTableContents profile;
  final MyPageTableContents attendanceInfo;
  final MyPageTableContents boulders;
  final int totalWorkoutTime;

  final int profileImageNumber;
  final BoulderLevel level;
  final Location location;

  const MyPageState({
    required this.profileImage,
    required this.introduction,
    required this.profile,
    required this.attendanceInfo,
    required this.boulders,
    required this.totalWorkoutTime,
    required this.profileImageNumber,
    required this.level,
    required this.location,
  });

  // copyWith
  MyPageState copyWith({
    String? profileImage,
    String? introduction,
    MyPageTableContents? profile,
    MyPageTableContents? attendanceInfo,
    MyPageTableContents? boulders,
    int? totalWorkoutTime,
    int? profileImageNumber,
    BoulderLevel? level,
    Location? location,
  }) {
    return MyPageState(
      profileImage: profileImage ?? this.profileImage,
      introduction: introduction ?? this.introduction,
      profile: profile ?? this.profile,
      attendanceInfo: attendanceInfo ?? this.attendanceInfo,
      boulders: boulders ?? this.boulders,
      totalWorkoutTime: totalWorkoutTime ?? this.totalWorkoutTime,
      profileImageNumber: profileImageNumber ?? this.profileImageNumber,
      level: level ?? this.level,
      location: location ?? this.location,
    );
  }
}

class ProfileUpdateState {
  /// Profile
  final Location? location;
  final BoulderLevel? level;
  final int? profileImageNumber;
  final String? introduction;

  const ProfileUpdateState({
    this.location,
    this.level,
    this.profileImageNumber,
    this.introduction,
  });
}

class MyPageViewModel extends ViewModel<MyPageEvent> {
  final Ref _ref;

  MyPageViewModel(this._ref) {
    _init().then((_) {
      updateUi(() {});
    }).catchError((e, stackTrace) {
      _errorHandler(e, stackTrace);
    }).whenComplete(() {});
  }

  MyPageState? _myPageState;
  MyPageState? get myPageState => _myPageState;

  Future<void> _init() async {
    await _fetchMyPage();
  }

  void refresh() {
    _init().then((_) {
      updateUi(() {});
    }).catchError((e, stackTrace) {
      _errorHandler(e, stackTrace);
    }).whenComplete(() {});
  }

  void updateProfile({
    required ProfileUpdateState profile,
  }) {
    emitEvent(MyPageEvent.showLoading);
    _ref.read(updateProfileUseCaseProvider(_toProfileUpdateModel(profile)).future).then((_) async {
      showSnackbar("프로필이 변경되었습니다.", MyPageEvent.showSnackbar);
      _fetchMyPage().then((_) {
        updateUi(() {});
      });
    }).catchError((e, stackTrace) {
      _errorHandler(e, stackTrace);
    }).whenComplete(() {
      emitEvent(MyPageEvent.hideLoading);
    });
  }

  Future<void> _fetchMyPage() async {
    await _ref.refresh(getMyPageUseCaseProvider.future).then((myPageModel) {
      _myPageState = MyPageState(
        profileImage: "assets/profiles/profile_${myPageModel.profile.profileImageNumber}.svg",
        introduction: myPageModel.profile.introduction,
        profile: [
          (field: "이름", value: myPageModel.profile.name),
          (field: "기수", value: myPageModel.profile.generation),
          (field: "역할", value: UserRole.toName[myPageModel.profile.role] ?? ""),
          (field: "운동 지점", value: Location.toName[myPageModel.profile.location] ?? ""),
          (field: "난이도", value: BoulderLevel.toName[myPageModel.profile.level] ?? ""),
        ],
        attendanceInfo: [
          (field: "출석", value: "${myPageModel.attendanceStats.attendance}회"),
          (field: "지각", value: "${myPageModel.attendanceStats.late}회"),
          (field: "결석", value: "${myPageModel.attendanceStats.absence}회"),
        ],
        boulders: myPageModel.records.map((record) {
          return (field: BoulderLevel.toName[record.level]!, value: "${record.count}개");
        }).toList(),
        totalWorkoutTime: myPageModel.totalWorkoutTime,
        profileImageNumber: myPageModel.profile.profileImageNumber,
        level: myPageModel.profile.level,
        location: myPageModel.profile.location,
      );
    });
  }

  ProfileUpdateModel _toProfileUpdateModel(ProfileUpdateState profile) {
    return ProfileUpdateModel(
      location: profile.location,
      level: profile.level,
      profileImageNumber: profile.profileImageNumber,
      introduction: profile.introduction,
    );
  }

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(MyPageEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        MyPageEvent.showSnackbar,
      ),
    );
  }
}

final myPageViewModelProvider = ViewModelProviderFactory.create((ref) {
  return MyPageViewModel(ref);
});
