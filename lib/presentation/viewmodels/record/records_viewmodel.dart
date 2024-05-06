import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/presentation/viewmodels/record/record_dates_viewmodel.dart';

import '../../../application/record/record_use_case.dart';
import '../../../constants/app_enum.dart';
import '../../../domain/record/boulder_problem.dart';
import '../../../domain/record/record.dart';
import '../../../utils/app_logger.dart';
import '../shared/exception_handler_on_viewmodel.dart';

part 'records_viewmodel.g.dart';

class RecordState {
  final int? id;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;
  final List<({BoulderLevel level, int count})> boulderProblems;

  const RecordState({
    this.id,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.boulderProblems,
  });
}

@riverpod
class RecordsViewmodel extends _$RecordsViewmodel {
  @override
  Future<List<RecordState>> build() async {
    logger.d('Execute RecordViewModel');
    late final List<RecordModel> records;
    try {
      records = await ref.refresh(getRecordsUseCaseProvider.future);
    } catch (e, stackTrace) {
      exceptionHandlerOnViewmodel(e: e as Exception, stackTrace: stackTrace);
    }
    return records.map(_fromRecordModel).toList();
  }

  RecordState _fromRecordModel(RecordModel record) {
    record.boulderProblems
        .sort((a, b) => a.level.index.compareTo(b.level.index));
    return RecordState(
      id: record.id,
      location: record.location,
      startTime: record.startTime,
      endTime: record.endTime,
      boulderProblems: record.boulderProblems
          .map(
            (problem) => (level: problem.level, count: problem.count),
          )
          .toList(),
    );
  }
}

enum RecordControllerAction {
  create,
  update,
  delete,
}

@riverpod
class RecordController extends _$RecordController {
  @override
  FutureOr<RecordControllerAction?> build() {
    return null;
  }

  Future<void> createRecord({
    required RecordState recordState,
  }) async {
    logger.d('Create Record');
    state = const AsyncLoading();
    state = await AsyncValue.guard<RecordControllerAction>(
      () async {
        try {
          await ref.refresh(
            createRecordUseCaseProvider(
              _toRecordModel(recordState),
            ).future,
          );
        } catch (e, stackTrace) {
          exceptionHandlerOnViewmodel(
              e: e as Exception, stackTrace: stackTrace);
        }
        return RecordControllerAction.create;
      },
    );
    ref.invalidate(recordsViewmodelProvider);
    ref.invalidate(recordDatesViewmodelProvider);
  }

  Future<void> updateRecord({
    required RecordState recordState,
  }) async {
    logger.d('Update Record');
    state = const AsyncLoading();
    state = await AsyncValue.guard<RecordControllerAction>(
      () async {
        try {
          await ref.refresh(
            updateRecordUseCaseProvider(
              _toRecordModel(recordState),
            ).future,
          );
        } catch (e, stackTrace) {
          exceptionHandlerOnViewmodel(
              e: e as Exception, stackTrace: stackTrace);
        }
        return RecordControllerAction.update;
      },
    );
    ref.invalidate(recordsViewmodelProvider);
    ref.invalidate(recordDatesViewmodelProvider);
  }

  Future<void> deleteRecord({
    required int id,
  }) async {
    logger.d('Delete Record');
    state = const AsyncLoading();
    state = await AsyncValue.guard<RecordControllerAction>(
      () async {
        try {
          await ref.refresh(
            deleteRecordUseCaseProvider(id).future,
          );
        } catch (e, stackTrace) {
          exceptionHandlerOnViewmodel(
              e: e as Exception, stackTrace: stackTrace);
        }
        return RecordControllerAction.delete;
      },
    );
    ref.invalidate(recordsViewmodelProvider);
    ref.invalidate(recordDatesViewmodelProvider);
  }

  RecordModel _toRecordModel(RecordState recordState) {
    return RecordModel(
      id: recordState.id,
      location: recordState.location,
      startTime: recordState.startTime,
      endTime: recordState.endTime,
      boulderProblems: recordState.boulderProblems
          .map(
            (problem) => BoulderProblem(
              level: problem.level,
              count: problem.count,
            ),
          )
          .toList(),
    );
  }
}
