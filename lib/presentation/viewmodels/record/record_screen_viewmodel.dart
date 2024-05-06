import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_screen_viewmodel.g.dart';

enum RecordScreenBottomSheetState {
  detail,
  create,
  edit,
  none,
}

class RecordScreenState {
  final RecordScreenBottomSheetState bottomSheetState;

  const RecordScreenState({
    required this.bottomSheetState,
  });
}

@riverpod
class RecordScreenViewmodel extends _$RecordScreenViewmodel {
  @override
  RecordScreenState build() {
    return RecordScreenState(
      bottomSheetState: RecordScreenBottomSheetState.none,
    );
  }

  void closeBottomSheet() {
    state = RecordScreenState(
      bottomSheetState: RecordScreenBottomSheetState.none,
    );
  }

  void openBottomSheet(RecordScreenBottomSheetState bottomSheetState) {
    state = RecordScreenState(
      bottomSheetState: bottomSheetState,
    );
  }
}
