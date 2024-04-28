import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/record/record_repository.dart';
import '../../domain/record/record.dart';
import '../../domain/record/record_dates.dart';
import '../../utils/app_logger.dart';

part 'record_use_case.g.dart';

@riverpod
Future<RecordDates> getRecordDatesUseCase(
  GetRecordDatesUseCaseRef ref,
) async {
  logger.d('Execute getRecordDatesUseCase');
  return await ref.read(recordRepositoryProvider).fetchRecordDates();
}

@riverpod
Future<List<RecordModel>> getRecordsUseCase(
  GetRecordsUseCaseRef ref,
) async {
  logger.d('Execute getRecordsUseCase');
  return await ref.read(recordRepositoryProvider).fetchRecords();
}

@riverpod
Future<void> createRecordUseCase(
  CreateRecordUseCaseRef ref,
  RecordModel record,
) async {
  logger.d('Execute createRecordUseCase');
  await ref.read(recordRepositoryProvider).createRecord(record: record);
}

@riverpod
Future<void> updateRecordUseCase(
  UpdateRecordUseCaseRef ref,
  RecordModel record,
) async {
  logger.d('Execute updateRecordUseCase');
  if (record.id == null) {
    throw Exception('Record id is null');
  }
  await ref.read(recordRepositoryProvider).updateRecord(record: record);
}

@riverpod
Future<void> deleteRecordUseCase(
  DeleteRecordUseCaseRef ref,
  int id,
) async {
  logger.d('Execute deleteRecordUseCase');
  await ref.read(recordRepositoryProvider).deleteRecord(id: id);
}
