import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/user/user_use_case.dart';
import '../../../constants/app_enum.dart';
import '../../../domain/user/profile.dart';
import '../../../utils/app_logger.dart';
import '../shared/exception_handler_on_viewmodel.dart';

part 'member_profile_viewmodel.g.dart';

class MemberProfileStateModel {
  /// Profile
  final String name;
  final String generation;
  final UserRole role;
  final Location location;
  final BoulderLevel level;
  final int profileImageNumber;
  final String introduction;

  const MemberProfileStateModel({
    required this.name,
    required this.generation,
    required this.role,
    required this.location,
    required this.level,
    required this.profileImageNumber,
    required this.introduction,
  });
}

@riverpod
class MemberProfileViewmodel extends _$MemberProfileViewmodel {
  @override
  Future<MemberProfileStateModel> build(int userId) async {
    logger.d('Execute MemberProfileViewModel');
    late final ProfileModel memberProfile;
    try {
      memberProfile =
          await ref.refresh(getOtherProfileUseCaseProvider(userId).future);
    } catch (e, stackTrace) {
      exceptionHandlerOnViewmodel(e: e as Exception, stackTrace: stackTrace);
    }
    return _fromMemberProfileModel(memberProfile);
  }

  MemberProfileStateModel _fromMemberProfileModel(ProfileModel memberProfile) {
    return MemberProfileStateModel(
      name: memberProfile.name,
      generation: memberProfile.generation,
      role: memberProfile.role,
      location: memberProfile.location,
      level: memberProfile.level,
      profileImageNumber: memberProfile.profileImageNumber,
      introduction: memberProfile.introduction,
    );
  }
}
