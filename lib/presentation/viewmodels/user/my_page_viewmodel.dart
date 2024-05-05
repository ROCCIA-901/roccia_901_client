import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/constants/app_enum.dart';

import '../../../application/user/user_use_case.dart';
import '../../../domain/user/profile.dart';
import '../../../utils/app_logger.dart';
import '../shared/exception_handler_on_viewmodel.dart';

part 'my_page_viewmodel.g.dart';

class MyPageState {
  /// Profile
  final String name;
  final String generation;
  final UserRole role;
  final Location location;
  final BoulderLevel level;
  final String profileImageUrl;
  final String introduction;

  // /// Attendance
  // final int presentCount;
  // final int absentCount;
  // final int lateCount;

  /// Record
  final List<({BoulderLevel level, int count})> boulderProblems;

  const MyPageState({
    required this.name,
    required this.generation,
    required this.role,
    required this.location,
    required this.level,
    required this.profileImageUrl,
    required this.introduction,
    // required this.presentCount,
    // required this.absentCount,
    // required this.lateCount,
    required this.boulderProblems,
  });
}

@riverpod
class MyPageViewmodel extends _$MyPageViewmodel {
  @override
  Future<MyPageState> build() async {
    logger.d('Execute MyPageViewModel');
    late final MyPageModel myPage;
    try {
      myPage = await ref.refresh(getMyPageUseCaseProvider.future);
    } catch (e, stackTrace) {
      exceptionHandlerOnViewmodel(e: e as Exception, stackTrace: stackTrace);
    }
    return _fromMyPageModel(myPage);
  }

  MyPageState _fromMyPageModel(MyPageModel myPage) {
    myPage.records.sort((a, b) => a.level.index.compareTo(b.level.index));
    return MyPageState(
      name: myPage.profile.name,
      generation: myPage.profile.generation,
      role: myPage.profile.role,
      location: myPage.profile.location,
      level: myPage.profile.level,
      profileImageUrl:
          "assets/profiles/profile_${myPage.profile.profileImageNumber}.svg",
      introduction: myPage.profile.introduction,
      // presentCount: myPage.attendance.presentCount,
      // absentCount: myPage.attendance.absentCount,
      // lateCount: myPage.attendance.lateCount,
      boulderProblems: myPage.records
          .map(
            (problem) => (level: problem.level, count: problem.count),
          )
          .toList(),
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

enum MyPageControllerAction {
  create,
  update,
  delete,
}

@riverpod
class MyPageController extends _$MyPageController {
  @override
  FutureOr<MyPageControllerAction?> build() {
    return null;
  }

  Future<void> updateMyPage({
    required ProfileUpdateState profile,
  }) async {
    logger.d('Update MyPage');
    state = const AsyncLoading();
    state = await AsyncValue.guard<MyPageControllerAction>(
      () async {
        try {
          await ref.refresh(
            updateProfileUseCaseProvider(
              _toProfileUpdateModel(profile),
            ).future,
          );
        } catch (e, stackTrace) {
          exceptionHandlerOnViewmodel(
              e: e as Exception, stackTrace: stackTrace);
        }
        return MyPageControllerAction.update;
      },
    );
    ref.invalidate(myPageViewmodelProvider);
  }

  ProfileUpdateModel _toProfileUpdateModel(ProfileUpdateState profile) {
    return ProfileUpdateModel(
      location: profile.location,
      level: profile.level,
      profileImageNumber: profile.profileImageNumber,
      introduction: profile.introduction,
    );
  }
}
