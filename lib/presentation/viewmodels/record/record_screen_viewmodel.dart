import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_screen_viewmodel.g.dart';

class RecordScreenState {
  final bool isBottomSheetOpened;

  const RecordScreenState({
    required this.isBottomSheetOpened,
  });
}

@riverpod
class RecordScreenViewmodel extends _$RecordScreenViewmodel {
  @override
  RecordScreenState build() {
    return RecordScreenState(
      isBottomSheetOpened: false,
    );
  }

  void toggleBottomSheet() {
    state = RecordScreenState(
      isBottomSheetOpened: !state.isBottomSheetOpened,
    );
  }

  void closeBottomSheet() {
    state = RecordScreenState(
      isBottomSheetOpened: false,
    );
  }

  void openBottomSheet() {
    state = RecordScreenState(
      isBottomSheetOpened: true,
    );
  }
}
