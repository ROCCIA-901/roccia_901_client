import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/data/shared/api_exception.dart';
import 'package:untitled/presentation/viewmodels/record/record_dates_viewmodel.dart';
import 'package:untitled/presentation/viewmodels/shared/notification_exception.dart';

import '../../../application/record/record_use_case.dart';
import '../../../constants/app_enum.dart';
import '../../../domain/record/boulder_problem.dart';
import '../../../domain/record/record.dart';
import '../../../utils/app_logger.dart';

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
class RecordsViewModel extends _$RecordsViewModel {
  @override
  Future<List<RecordState>> build() async {
    logger.d('Execute RecordViewModel');
    final List<RecordModel> records =
        await ref.refresh(getRecordsUseCaseProvider.future);
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
        } on ApiException catch (e) {
          throw NotificationException(e.message);
        } catch (e, stackTrace) {
          logger.e('Create Record Error', error: e, stackTrace: stackTrace);
          rethrow;
        }
        return RecordControllerAction.create;
      },
    );
    ref.invalidate(recordsViewModelProvider);
    ref.invalidate(recordDatesViewModelProvider);
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
        } on ApiException catch (e) {
          throw NotificationException(e.message);
        } catch (e, stackTrace) {
          logger.e('Update Record Error', error: e, stackTrace: stackTrace);
          rethrow;
        }
        return RecordControllerAction.update;
      },
    );
    ref.invalidate(recordsViewModelProvider);
    ref.invalidate(recordDatesViewModelProvider);
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
        } on ApiException catch (e) {
          throw NotificationException(e.message);
        } catch (e, stackTrace) {
          logger.e('Delete Record Error', error: e, stackTrace: stackTrace);
          rethrow;
        }
        return RecordControllerAction.delete;
      },
    );
    ref.invalidate(recordsViewModelProvider);
    ref.invalidate(recordDatesViewModelProvider);
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
