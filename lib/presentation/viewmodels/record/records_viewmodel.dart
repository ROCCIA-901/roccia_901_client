import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/record/record_use_case.dart';
import '../../../constants/app_enum.dart';
import '../../../domain/record/record.dart';
import '../../../utils/app_logger.dart';

part 'records_viewmodel.g.dart';

class RecordState {
  final int id;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final List<({String level, int count})> boulderProblems;

  const RecordState({
    required this.id,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.boulderProblems,
  });
}

@riverpod
class RecordsViewModel extends _$RecordsViewModel {
  @override
  Future<List<RecordState>> build() async {
    logger.d('Execute RecordViewModel');
    final List<RecordModel> records =
        await ref.refresh(getRecordsUseCaseProvider.future);
    return records.map(_toRecordState).toList();
  }

  RecordState _toRecordState(RecordModel record) {
    record.boulderProblems
        .sort((a, b) => a.level.index.compareTo(b.level.index));
    return RecordState(
      id: record.id,
      location: Location.toName[record.location]!,
      startTime: record.startTime,
      endTime: record.endTime,
      boulderProblems: record.boulderProblems
          .map(
            (problem) => (
              level: BoulderLevel.toName[problem.level]!,
              count: problem.numberOfCompletions
            ),
          )
          .toList(),
    );
  }
}
