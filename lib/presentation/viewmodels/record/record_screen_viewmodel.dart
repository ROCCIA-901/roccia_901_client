import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/app_logger.dart';

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
    logger.wtf('vm: closeBottomSheet',
        error: Exception(), stackTrace: StackTrace.current);
    state = RecordScreenState(
      bottomSheetState: RecordScreenBottomSheetState.none,
    );
  }

  void openBottomSheet(RecordScreenBottomSheetState bottomSheetState) {
    logger.wtf('vm: openBottomSheet',
        error: Exception(), stackTrace: StackTrace.current);
    state = RecordScreenState(
      bottomSheetState: bottomSheetState,
    );
  }
}
