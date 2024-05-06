import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/user/user_repository.dart';
import '../../domain/user/profile.dart';
import '../../utils/app_logger.dart';

part 'user_use_case.g.dart';

@riverpod
Future<MyPageModel> getMyPageUseCase(
  GetMyPageUseCaseRef ref,
) async {
  logger.d('Execute getProfileUseCase');
  return await ref.read(userRepositoryProvider).fetchMyPage();
}

@riverpod
Future<void> updateProfileUseCase(
  UpdateProfileUseCaseRef ref,
  ProfileUpdateModel profile,
) async {
  logger.d('Execute updateProfileUseCase');
  await ref.read(userRepositoryProvider).updateProfile(profile: profile);
}
