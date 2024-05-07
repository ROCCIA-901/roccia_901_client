import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_screen_viewmodel.g.dart';

enum RecordScreenBottomSheetType {
  detail,
  create,
  edit,
  none,
}

class RecordScreenStateModel {
  final RecordScreenBottomSheetType bottomSheetState;

  const RecordScreenStateModel({
    required this.bottomSheetState,
  });
}

@riverpod
class RecordScreenViewmodel extends _$RecordScreenViewmodel {
  @override
  RecordScreenStateModel build() {
    return RecordScreenStateModel(
      bottomSheetState: RecordScreenBottomSheetType.none,
    );
  }

  void closeBottomSheet() {
    state = RecordScreenStateModel(
      bottomSheetState: RecordScreenBottomSheetType.none,
    );
  }

  void openBottomSheet(RecordScreenBottomSheetType bottomSheetState) {
    state = RecordScreenStateModel(
      bottomSheetState: bottomSheetState,
    );
  }
}
