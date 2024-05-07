import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/presentation/screens/shared/exception_handler_on_view.dart';
import 'package:untitled/presentation/viewmodels/record/record_screen_viewmodel.dart';
import 'package:untitled/utils/snack_bar_helper.dart';
import 'package:untitled/utils/time_of_day_utils.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_calendar.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_enum.dart';
import '../../../constants/size_config.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/confirm_popup.dart';
import '../../viewmodels/record/record_dates_viewmodel.dart';
import '../../viewmodels/record/records_viewmodel.dart';

class MyRecordTab extends ConsumerStatefulWidget {
  const MyRecordTab({super.key});

  @override
  ConsumerState<MyRecordTab> createState() => _MyRecordTabState();
}

class _MyRecordTabState extends ConsumerState<MyRecordTab>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  DateTime? _displayedDate;
  DateTime? _focusedDate;

  late final AnimationController _recordDetailAnimationController;

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _calendarWidth;
  late double _calendarHeight;
  late double _recordDetailHeight;
  late double _buttonWidth;
  late double _buttonHeight;

  @override
  void initState() {
    super.initState();
    _recordDetailAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateSize(context);

    var recordDatesState = ref.watch(recordDatesViewmodelProvider);
    var recordsState = ref.watch(recordsViewmodelProvider);

    _setListeners();

    if ((recordDatesState is! AsyncData || recordDatesState.value == null) &&
        (recordsState is! AsyncData || recordsState.value == null)) {
      if (recordDatesState is AsyncError) {
        exceptionHandlerOnView(
          context,
          e: recordDatesState.error as Exception,
          stackTrace: recordDatesState.stackTrace ?? StackTrace.current,
        );
      }
      if (recordsState is AsyncError) {
        exceptionHandlerOnView(
          context,
          e: recordsState.error as Exception,
          stackTrace: recordsState.stackTrace ?? StackTrace.current,
        );
      }
      return Center(child: CircularProgressIndicator());
    }

    _focusedDate = _selectedDate ?? _focusedDate;
    return Column(
      children: [
        SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
        AppCalendar(
          width: _calendarWidth,
          height: _calendarHeight,
          focusedDay: _focusedDate,
          selectedDay: _selectedDate,
          onSelected: (date) {
            _onDateSelected(date, recordsState);
          },
          eventsSource: switch (recordDatesState) {
            AsyncData(:final value) => value.eventsSource,
            _ => {},
          },
        ),

        /// 기록 상세 창
        Expanded(child: SizedBox()),

        /// 버튼
        Container(
          margin: EdgeInsets.only(
              bottom: AppSize.of(context).safeBlockVertical * 5),
          alignment: Alignment.center,
          child: _buildRecordButton(
            text: "기록하기",
            width: _buttonWidth,
            height: _buttonHeight,
            onPressed: _showCreateRecordForm,
          ),
        ),
      ],
    );
  }

  void _updateSize(BuildContext context) {
    _calendarWidth = AppSize.of(context).safeBlockHorizontal * 90;
    _calendarHeight = _calendarWidth * 0.8;
    _recordDetailHeight = AppSize.of(context).safeBlockVertical * 42;
    _buttonWidth = AppSize.of(context).safeBlockHorizontal * 80;
    _buttonHeight = _buttonWidth * 0.15;
  }

  void _onDateSelected(
      DateTime date, AsyncValue<List<RecordState>> recordsState) {
    if (recordsState.value == null) {
      return;
    }
    final bool isSelectDayInRecords =
        _isDayInRecords(date, recordsState.value!);
    if (isSelectDayInRecords) {
      _showRecordDetail(recordsState, date);
      _displayedDate = date;
    } else if (ref.read(recordScreenViewmodelProvider).bottomSheetState !=
        RecordScreenBottomSheetType.none) {
      // 기록 없는 날을 선택할 시,
      _resetDisplayedDate();
      _closeBottomSheet();
    }
    setState(() {
      _selectedDate = date;
    });
  }

  void _onBackAtRecordDetail(DateTime prevDisplayedDate) {
    if (ref.read(recordScreenViewmodelProvider).bottomSheetState !=
        RecordScreenBottomSheetType.detail) {
      if (ref.read(recordScreenViewmodelProvider).bottomSheetState ==
          RecordScreenBottomSheetType.none) {
        _resetSelectedDate();
        _resetDisplayedDate();
      }
      return;
    }
    if (_displayedDate != null &&
        isSameDay(_displayedDate!, prevDisplayedDate)) {
      ref.read(recordScreenViewmodelProvider.notifier).closeBottomSheet();
      _resetSelectedDate();
      _resetDisplayedDate();
    }
  }

  void _resetSelectedDate() {
    setState(() {
      _selectedDate = null;
    });
  }

  void _resetDisplayedDate() {
    setState(() {
      _displayedDate = null;
    });
  }

  bool _isDayInRecords(DateTime date, List<RecordState> records) {
    for (final record in records) {
      if (isSameDay(record.startTime, date)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildRecordButton({
    required String text,
    required double width,
    required double height,
    void Function()? onPressed,
  }) {
    Color backgroundColor = AppColors.primary;
    if (_selectedDate == null) {
      backgroundColor = AppColors.greyLight;
      onPressed = () {
        SnackBarHelper.showTextSnackBar(context, "날짜를 선택해주세요.");
      };
    }
    return SizedBox(
      width: width,
      height: height,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: backgroundColor,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: onPressed ?? () {},
      ),
    );
  }

  void _showCreateRecordForm() {
    setState(() {
      _selectedDate = _selectedDate ?? DateTime.now();
    });
    _openBottomSheet(
      bottomSheetState: RecordScreenBottomSheetType.create,
      showBottomSheet: () {
        showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
            maxHeight: _recordDetailHeight,
            maxWidth: double.infinity,
          ),
          enableDrag: false,
          showDragHandle: false,
          builder: (context) {
            return _CreateRecordBottomSheet(
              selectedDate: _selectedDate!,
              createRecord: _createRecord,
            );
          },
        ).whenComplete(() {
          if (ref.read(recordScreenViewmodelProvider).bottomSheetState ==
              RecordScreenBottomSheetType.create) {
            ref.read(recordScreenViewmodelProvider.notifier).closeBottomSheet();
            _resetSelectedDate();
            _resetDisplayedDate();
          }
        });
      },
    );
  }

  void _showRecordDetail(
    final AsyncValue<List<RecordState>> recordsState,
    final DateTime selectedDate,
  ) async {
    _openBottomSheet(
      bottomSheetState: RecordScreenBottomSheetType.detail,
      showBottomSheet: () {
        final recordDetailController = showBottomSheet(
          context: context,
          constraints: BoxConstraints(
            maxHeight: _recordDetailHeight,
            maxWidth: double.infinity,
          ),
          builder: (context) {
            return _RecordDetailWidget(
              height: _recordDetailHeight,
              recordsState: recordsState,
              selectedDate: selectedDate,
              deleteRecord: _deleteRecord,
              showUpdateRecordForm: _showUpdateRecordForm,
              closeBottomSheet: _closeBottomSheet,
            );
          },
          elevation: 0,
          enableDrag: false,
          transitionAnimationController: _recordDetailAnimationController,
        );
        recordDetailController.closed.then((value) {
          _onBackAtRecordDetail(selectedDate);
        });
      },
    );
  }

  void _showUpdateRecordForm(RecordState recordState) {
    _openBottomSheet(
      bottomSheetState: RecordScreenBottomSheetType.edit,
      showBottomSheet: () {
        showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
            maxHeight: _recordDetailHeight,
            maxWidth: double.infinity,
          ),
          enableDrag: false,
          showDragHandle: false,
          builder: (context) {
            return _UpdateRecordBottomSheet(
              recordState: recordState,
              updateRecord: _updateRecord,
            );
          },
        ).whenComplete(() {
          if (ref.read(recordScreenViewmodelProvider).bottomSheetState ==
              RecordScreenBottomSheetType.edit) {
            ref.read(recordScreenViewmodelProvider.notifier).closeBottomSheet();
            _resetSelectedDate();
            _resetDisplayedDate();
          }
        });
      },
    );
  }

  void _openBottomSheet({
    required RecordScreenBottomSheetType bottomSheetState,
    required VoidCallback showBottomSheet,
  }) {
    bool isDetailToDetail =
        ref.read(recordScreenViewmodelProvider).bottomSheetState ==
                RecordScreenBottomSheetType.detail &&
            bottomSheetState == RecordScreenBottomSheetType.detail;
    if (!isDetailToDetail) {
      _closeBottomSheet();
      ref
          .read(recordScreenViewmodelProvider.notifier)
          .openBottomSheet(bottomSheetState);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showBottomSheet();
    });
  }

  void _closeBottomSheet() {
    if (ref.read(recordScreenViewmodelProvider).bottomSheetState !=
        RecordScreenBottomSheetType.none) {
      Navigator.of(context).pop();
      ref.read(recordScreenViewmodelProvider.notifier).closeBottomSheet();
    }
  }

  void _createRecord(RecordState recordState) {
    _closeBottomSheet();
    ref
        .read(recordControllerProvider.notifier)
        .createRecord(recordState: recordState)
        .whenComplete(() {
      _showRecordDetail(
        AsyncValue.data([recordState]),
        recordState.startTime,
      );
    });
  }

  void _updateRecord(RecordState recordState) {
    ref
        .read(recordControllerProvider.notifier)
        .updateRecord(recordState: recordState)
        .whenComplete(() {
      _closeBottomSheet();
      _showRecordDetail(
        AsyncValue.data([recordState]),
        recordState.startTime,
      );
    });
  }

  void _deleteRecord(int id) {
    _closeBottomSheet();
    ref.read(recordControllerProvider.notifier).deleteRecord(id: id);
  }

  // ------------------------------------------------------------------------ //
  // Notification Listeners                                                   //
  // ------------------------------------------------------------------------ //
  void _setListeners() {
    _listenRecordsViewModel();
    _listenRecordController();
  }

  void _listenRecordsViewModel() {
    ref.listen(
      recordsViewmodelProvider,
      (previous, next) {
        next.when(
          data: (_) {},
          loading: () {},
          error: (error, stackTrace) {
            if (error is Exception) {
              exceptionHandlerOnView(context, e: error, stackTrace: stackTrace);
            }
          },
        );
      },
    );
  }

  void _listenRecordController() {
    ref.listen(
      recordControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is! AsyncLoading) {
              return;
            }
            Navigator.pop(context);
            final message = switch (data) {
              RecordControllerAction.create => "기록이 생성되었습니다.",
              RecordControllerAction.update => "기록이 수정되었습니다.",
              RecordControllerAction.delete => "기록이 삭제되었습니다.",
              _ => null,
            };
            if (message != null) {
              ToastHelper.show(context, message);
            } else {
              ToastHelper.showErrorOccurred(context);
            }
          },
          loading: () {
            DialogHelper.showLoaderDialog(context);
          },
          error: (error, stackTrace) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
            }
            if (error is Exception) {
              exceptionHandlerOnView(context, e: error, stackTrace: stackTrace);
            }
          },
        );
      },
    );
  }
}

class _RecordDetailWidget extends StatelessWidget {
  final AsyncValue<List<RecordState>> recordsState;
  final double _height;
  late final DateTime _selectedDate;
  late final RecordState? _record;
  final void Function(RecordState recordState) _showUpdateRecordForm;
  final void Function(int id) _deleteRecord;
  final void Function() _closeBottomSheet;

  _RecordDetailWidget({
    Key? key,
    required this.recordsState,
    required double height,
    required DateTime selectedDate,
    required void Function(RecordState recordState) showUpdateRecordForm,
    required void Function(int id) deleteRecord,
    required void Function() closeBottomSheet,
  })  : _selectedDate = selectedDate,
        _height = height,
        _showUpdateRecordForm = showUpdateRecordForm,
        _deleteRecord = deleteRecord,
        _closeBottomSheet = closeBottomSheet,
        super(key: key) {
    switch (recordsState) {
      case (AsyncData(:final value)):
        _record = _findRecord(value, _selectedDate);
        break;
      default:
        _record = null;
        break;
    }
  }

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _labelWidth;
  late double _labelHeight;
  late double _contentWidth;
  late double _contentHeight;
  late double _levelContentWidth;
  late double _countContentWidth;
  late double _buttonHeight;
  late double _buttonWidth;
  late double _buttonBottomMargin;

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    if (recordsState is AsyncLoading || recordsState is AsyncError) {
      return Center(child: CircularProgressIndicator());
    }
    if (_record == null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(height: 1.5, color: AppColors.greyLight),
      );
    }
    final String location = Location.toName[_record!.location]!;
    final String timeDuration =
        "${DateFormat("HH:mm").format(_record!.startTime)} ~ ${DateFormat("HH:mm").format(_record!.endTime)}";
    final List<({BoulderLevel level, int count})> boulderProblems =
        _record!.boulderProblems;
    return BottomSheet(
        constraints: BoxConstraints(
          maxHeight: _height,
          maxWidth: double.infinity,
        ),
        onClosing: () {},
        builder: (context) => Container(
              height: _height,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// 가로선
                  Container(height: 1.5, color: AppColors.greyLight),

                  /// 닫기 버튼
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(
                        top: AppSize.of(context).safeBlockHorizontal * 2,
                        right: AppSize.of(context).safeBlockHorizontal * 3),
                    child: IconButton(
                      constraints: BoxConstraints(
                        minHeight: AppSize.of(context).safeBlockHorizontal * 7,
                        maxHeight: AppSize.of(context).safeBlockHorizontal * 7,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _closeBottomSheet();
                      },
                      icon: Icon(Icons.close_rounded,
                          size: AppSize.of(context).safeBlockHorizontal * 7,
                          color: AppColors.greyMedium),
                    ),
                  ),

                  /// 기록 상세
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildLabel(context, "지점"),
                              _buildContent(context, location)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildLabel(context, "시간"),
                              _buildContent(context, timeDuration)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, "완등한 문제"),
                              Column(
                                children: List<Row>.generate(
                                  boulderProblems.length,
                                  (index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildContent(
                                          context,
                                          BoulderLevel.toName[
                                              boulderProblems[index].level]!,
                                          width: _levelContentWidth,
                                        ),
                                        _buildContent(
                                          context,
                                          "${boulderProblems[index].count.toString()}개",
                                          width: _countContentWidth,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.of(context).safeBlockVertical * 1.5),

                  /// 버튼
                  _buildButtons(context),
                ],
              ),
            ));
  }

  void _updateSize(BuildContext context) {
    _labelWidth = AppSize.of(context).safeBlockHorizontal * 40;
    _labelHeight = AppSize.of(context).safeBlockHorizontal * 10;
    _contentWidth = AppSize.of(context).safeBlockHorizontal * 60;
    _contentHeight = AppSize.of(context).safeBlockHorizontal * 8;
    _levelContentWidth = AppSize.of(context).safeBlockHorizontal * 25;
    _countContentWidth = AppSize.of(context).safeBlockHorizontal * 35;
    _buttonHeight = AppSize.of(context).safeBlockHorizontal * 12;
    _buttonWidth = AppSize.of(context).safeBlockHorizontal * 37;
    _buttonBottomMargin = AppSize.of(context).safeBlockVertical * 5;
  }

  RecordState? _findRecord(List<RecordState> records, DateTime date) {
    for (final record in records) {
      if (isSameDay(record.startTime, date)) {
        return record;
      }
    }
    return null;
  }

  Container _buildLabel(BuildContext context, String label) {
    final double labelWidth = _labelWidth;
    final double labelHeight = _labelHeight;
    return Container(
      width: labelWidth,
      height: labelHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(left: AppSize.of(context).safeBlockHorizontal * 13),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
          ).copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Container _buildContent(BuildContext context, String content,
      {double? width}) {
    final double contentWidth = width ?? _contentWidth;
    final double contentHeight = _contentHeight;
    return Container(
      width: contentWidth,
      height: contentHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(left: AppSize.of(context).safeBlockHorizontal * 10),
        child: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.normal,
          ).copyWith(color: AppColors.greyDark),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _buttonBottomMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            context: context,
            text: "삭제하기",
            width: _buttonWidth,
            height: _buttonHeight,
            backgroundColor: AppColors.redMedium,
            onPressed: () {
              _onPressedDelete(context, id: _record!.id!);
            },
          ),
          _buildButton(
            context: context,
            text: "수정하기",
            width: _buttonWidth,
            height: _buttonHeight,
            backgroundColor: AppColors.primary,
            onPressed: () {
              _showUpdateRecordForm(_record!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required double width,
    required double height,
    required Color backgroundColor,
    void Function()? onPressed,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: backgroundColor,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: onPressed ?? () {},
      ),
    );
  }

  Future<void> _onPressedDelete(
    BuildContext context, {
    required int id,
  }) async {
    final wantDelete = await showDialog(
      context: context,
      builder: (_) => ConfirmPopup(
        width: AppSize.of(context).safeBlockHorizontal * 70,
        height: AppSize.of(context).safeBlockVertical * 14,
        content: Text(
          "정말로 기록을 삭제하실 건가요?",
          style: TextStyle(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4,
          ),
        ),
        actions: [
          ConfirmPopupButton(
            width: AppSize.of(context).safeBlockHorizontal * 25,
            content: Text(
              "아니오",
              style: TextStyle(
                color: AppColors.greyDark,
                fontSize: AppSize.of(context).safeBlockHorizontal * 3.0,
              ),
            ),
            backgroundColor: AppColors.greyLight,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ConfirmPopupButton(
            width: AppSize.of(context).safeBlockHorizontal * 25,
            content: Text(
              "예",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.of(context).safeBlockHorizontal * 3.0,
              ),
            ),
            backgroundColor: AppColors.redMedium,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (wantDelete) {
      _deleteRecord(id);
    }
  }
}

class _CreateRecordBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(RecordState) createRecord;
  const _CreateRecordBottomSheet({
    required this.selectedDate,
    required this.createRecord,
  });

  @override
  State<_CreateRecordBottomSheet> createState() =>
      _CreateRecordBottomSheetState();
}

class _CreateRecordBottomSheetState extends State<_CreateRecordBottomSheet> {
  /// state
  Location? _selectedLocation;
  TimeOfDay _startTime =
      TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(hours: 2)));
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(minutes: 1)));
  late List<({BoulderLevel? level, int? count})> _boulderProblems;

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _width;
  late double _height;
  late double _borderRadius;
  late double _formHeight;
  late double _labelWidth;
  late double _labelHeight;
  late double _contentWidth;
  late double _contentHeight;
  late double _timeFormWidth;
  late double _timeFormDistance;
  late double _levelContentWidth;
  late double _countContentWidth;
  late double _circleButtonSize;
  late double _buttonWidth;
  late double _buttonHeight;

  @override
  void initState() {
    super.initState();
    _boulderProblems = [(level: null, count: null)];
  }

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return BottomSheet(
      constraints: BoxConstraints(
        maxHeight: _height,
        maxWidth: double.infinity,
      ),
      builder: (context) {
        return Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                topRight: Radius.circular(_borderRadius),
              ),
            ),
            child: Column(
              children: [
                /// 드래그 핸들바 & 닫기 버튼
                SizedBox(
                  width: AppSize.of(context).safeBlockHorizontal * 100,
                  height: AppSize.of(context).safeBlockVertical * 6,
                  child: Stack(
                    children: [
                      /// 드래그 핸들바
                      Align(
                        alignment: Alignment.center,
                        child: _buildDragHandle(),
                      ),

                      /// 닫기 버튼
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: AppSize.of(context).safeBlockHorizontal * 7,
                            color: AppColors.greyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 기록 입력 폼
                Expanded(child: _buildCreateRecordForm()),

                /// 버튼
                Container(
                  margin: EdgeInsets.only(
                      top: AppSize.of(context).safeBlockHorizontal * 2,
                      bottom: AppSize.of(context).safeBlockHorizontal * 5),
                  alignment: Alignment.center,
                  child: _buildButton(
                    text: "저장하기",
                    width: _buttonWidth,
                    height: _buttonHeight,
                  ),
                ),
              ],
            ));
      },
      onClosing: () {},
    );
  }

  void _updateSize(BuildContext context) {
    _width = AppSize.of(context).safeBlockHorizontal * 100;
    _height = AppSize.of(context).safeBlockVertical * 50;
    _borderRadius = AppSize.of(context).safeBlockHorizontal * 6;
    _formHeight = AppSize.of(context).safeBlockVertical * 30;
    _labelWidth = AppSize.of(context).safeBlockHorizontal * 40;
    _labelHeight = AppSize.of(context).safeBlockVertical * 6;
    _contentWidth = AppSize.of(context).safeBlockHorizontal * 60;
    _contentHeight = AppSize.of(context).safeBlockVertical * 4.2;
    _timeFormWidth = AppSize.of(context).safeBlockHorizontal * 20;
    _timeFormDistance = AppSize.of(context).safeBlockHorizontal * 10;
    _levelContentWidth = AppSize.of(context).safeBlockHorizontal * 23;
    _countContentWidth = AppSize.of(context).safeBlockHorizontal * 18;
    _circleButtonSize = AppSize.of(context).safeBlockHorizontal * 5;
    _buttonWidth = AppSize.of(context).safeBlockHorizontal * 80;
    _buttonHeight = AppSize.of(context).safeBlockHorizontal * 12;
  }

  Container _buildDragHandle() {
    return Container(
      width: AppSize.of(context).safeBlockHorizontal * 13,
      height: AppSize.of(context).safeBlockVertical * 0.5,
      decoration: BoxDecoration(
        color: AppColors.greyMedium,
        borderRadius:
            BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 3),
      ),
    );
  }

  Container _buildLabel(String label) {
    final double labelWidth = _labelWidth;
    final double labelHeight = _labelHeight;
    return Container(
      width: labelWidth,
      height: labelHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(left: AppSize.of(context).safeBlockHorizontal * 13),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
          ).copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildCreateRecordForm() {
    final double contentLeftPadding =
        AppSize.of(context).safeBlockHorizontal * 10;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabel("지점"),
              Container(
                width: _contentWidth,
                height: _contentHeight,
                padding: EdgeInsets.only(
                  right: contentLeftPadding,
                ),
                child: _GenericDropdown<Location>(
                  values: Location.values,
                  toName: Location.toName,
                  selectedValue: _selectedLocation,
                  onChanged: _changeLocation,
                  hintText: "지점을 선택해주세요",
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabel("시간"),
              _TimeForm(
                width: _timeFormWidth,
                height: _contentHeight,
                initialTime: _startTime,
                onChanged: (time) {
                  setState(() {
                    _startTime = time;
                  });
                },
                borderColor: _endTime.compareTo(_startTime) > 0
                    ? AppColors.greyMediumDark
                    : AppColors.redMedium,
              ),
              SizedBox(
                width: _timeFormDistance,
                child: Align(
                    child: Text(
                  "~",
                  style: GoogleFonts.roboto().copyWith(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 4.5,
                    color: AppColors.greyMedium,
                  ),
                )),
              ),
              _TimeForm(
                width: _timeFormWidth,
                height: _contentHeight,
                initialTime: _endTime,
                onChanged: (time) {
                  setState(() {
                    _endTime = time;
                  });
                },
                borderColor: _endTime.compareTo(_startTime) > 0
                    ? AppColors.greyMediumDark
                    : AppColors.redMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("완등한 문제"),
              Column(
                children: _buildBoulderProblemFormList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeLocation(Location? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  List<Widget> _buildBoulderProblemFormList() {
    final double contentLeftPadding =
        AppSize.of(context).safeBlockHorizontal * 10;
    return List.generate(
      _boulderProblems.length,
      (index) {
        return Container(
          width: _contentWidth,
          height: _labelHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            right: contentLeftPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBoulderProblemDropdown(index),
              _buildCountDropdown(index),
              index == (_boulderProblems.length - 1)
                  ? _buildPlusButton()
                  : _buildMinusButton(index),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBoulderProblemDropdown(int index) {
    return SizedBox(
      width: _levelContentWidth,
      height: _contentHeight,
      child: _GenericDropdown<BoulderLevel>(
        values: BoulderLevel.values,
        toName: BoulderLevel.toName,
        selectedValue: _boulderProblems[index].level,
        onChanged: (level) {
          setState(() {
            _boulderProblems[index] =
                (level: level, count: _boulderProblems[index].count);
          });
        },
        hintText: "난이도",
      ),
    );
  }

  Widget _buildCountDropdown(int index) {
    return SizedBox(
      width: _countContentWidth,
      height: _contentHeight,
      child: _CountDropdown(
        selectedValue: _boulderProblems[index].count,
        onChanged: (count) {
          setState(
            () {
              _boulderProblems[index] =
                  (level: _boulderProblems[index].level, count: count);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlusButton() {
    return _buildCircleButton(
      'assets/icons/plus_circle.svg',
      () {
        setState(() {
          _boulderProblems.add((level: null, count: null));
        });
      },
    );
  }

  Widget _buildMinusButton(int index) {
    return _buildCircleButton(
      'assets/icons/minus_circle.svg',
      () {
        setState(() {
          _boulderProblems.removeAt(index);
        });
      },
    );
  }

  Widget _buildCircleButton(String iconPath, VoidCallback onPressed) {
    return Container(
      width: _circleButtonSize * 1.2,
      height: _circleButtonSize * 1.2,
      alignment: Alignment.center,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: SvgPicture.asset(
          iconPath,
          width: _circleButtonSize,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: _onPressedCreateRecord,
      ),
    );
  }

  void _onPressedCreateRecord() {
    if (_hasEmptyField()) {
      ToastHelper.show(context, "모든 항목을 입력해주세요.");
      return;
    }
    if (_hasDuplicateBoulderLevel()) {
      ToastHelper.show(context, "중복되는 난이도가 있어요.");
      return;
    }
    if (_endTimeIsBeforeStartTime()) {
      ToastHelper.show(context, "종료 시간이 시작 시간보다 빨라요.\n당신은 시간의 마술사?");
      return;
    }
    if (_endTimeIsAfterCurrentTime()) {
      ToastHelper.show(context, "종료 시간이 현재 시간보다 늦어요.\n당신은 시간의 마술사?");
      return;
    }
    widget.createRecord(
      RecordState(
        location: _selectedLocation!,
        startTime: widget.selectedDate.copyWith(
          hour: _startTime.hour,
          minute: _startTime.minute,
        ),
        endTime: widget.selectedDate.copyWith(
          hour: _endTime.hour,
          minute: _endTime.minute,
        ),
        boulderProblems:
            List<({BoulderLevel level, int count})>.from(_boulderProblems),
      ),
    );
  }

  bool _hasEmptyField() {
    if (_selectedLocation == null) {
      return true;
    }
    for (final boulderProblem in _boulderProblems) {
      if (boulderProblem.level == null || boulderProblem.count == null) {
        return true;
      }
    }
    return false;
  }

  bool _hasDuplicateBoulderLevel() {
    final List<BoulderLevel?> levels =
        _boulderProblems.map((e) => e.level).toList();
    return levels.toSet().length != levels.length;
  }

  bool _endTimeIsBeforeStartTime() {
    return _endTime.compareTo(_startTime) <= 0;
  }

  bool _endTimeIsAfterCurrentTime() {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.now();
    if (widget.selectedDate.year != currentDate.year) {
      return widget.selectedDate.year > currentDate.year;
    }
    if (widget.selectedDate.month != currentDate.month) {
      return widget.selectedDate.month > currentDate.month;
    }
    if (widget.selectedDate.day != currentDate.day) {
      return widget.selectedDate.day > currentDate.day;
    }
    return _endTime.compareTo(currentTime) > 0;
  }
}

class _UpdateRecordBottomSheet extends StatefulWidget {
  final RecordState recordState;
  final void Function(RecordState) updateRecord;
  const _UpdateRecordBottomSheet({
    required this.recordState,
    required this.updateRecord,
  });

  @override
  State<_UpdateRecordBottomSheet> createState() =>
      _UpdateRecordBottomSheetState();
}

class _UpdateRecordBottomSheetState extends State<_UpdateRecordBottomSheet> {
  /// state
  late Location _selectedLocation;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<({BoulderLevel? level, int? count})> _boulderProblems;

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _width;
  late double _height;
  late double _borderRadius;
  late double _formHeight;
  late double _labelWidth;
  late double _labelHeight;
  late double _contentWidth;
  late double _contentHeight;
  late double _timeFormWidth;
  late double _timeFormDistance;
  late double _levelContentWidth;
  late double _countContentWidth;
  late double _circleButtonSize;
  late double _buttonWidth;
  late double _buttonHeight;

  @override
  void initState() {
    super.initState();

    _selectedLocation = widget.recordState.location;
    _startTime = TimeOfDay.fromDateTime(widget.recordState.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.recordState.endTime);
    _boulderProblems = List.from(widget.recordState.boulderProblems);
  }

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return BottomSheet(
      constraints: BoxConstraints(
        maxHeight: _height,
        maxWidth: double.infinity,
      ),
      builder: (context) {
        return Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                topRight: Radius.circular(_borderRadius),
              ),
            ),
            child: Column(
              children: [
                /// 드래그 핸들바 & 닫기 버튼
                SizedBox(
                  width: AppSize.of(context).safeBlockHorizontal * 100,
                  height: AppSize.of(context).safeBlockVertical * 6,
                  child: Stack(
                    children: [
                      /// 드래그 핸들바
                      Align(
                        alignment: Alignment.center,
                        child: _buildDragHandle(),
                      ),

                      /// 닫기 버튼
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_rounded,
                              size: AppSize.of(context).safeBlockHorizontal * 7,
                              color: AppColors.greyMedium),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 기록 입력 폼
                Expanded(child: _buildCreateRecordForm()),

                /// 버튼
                Container(
                  margin: EdgeInsets.only(
                    top: AppSize.of(context).safeBlockHorizontal * 2,
                    bottom: AppSize.of(context).safeBlockHorizontal * 5,
                  ),
                  alignment: Alignment.center,
                  child: _buildButton(
                    text: "저장하기",
                    width: _buttonWidth,
                    height: _buttonHeight,
                  ),
                ),
              ],
            ));
      },
      onClosing: () {},
    );
  }

  void _updateSize(BuildContext context) {
    _width = AppSize.of(context).safeBlockHorizontal * 100;
    _height = AppSize.of(context).safeBlockVertical * 50;
    _borderRadius = AppSize.of(context).safeBlockHorizontal * 6;
    _formHeight = AppSize.of(context).safeBlockVertical * 30;
    _labelWidth = AppSize.of(context).safeBlockHorizontal * 40;
    _labelHeight = AppSize.of(context).safeBlockVertical * 6;
    _contentWidth = AppSize.of(context).safeBlockHorizontal * 60;
    _contentHeight = AppSize.of(context).safeBlockVertical * 4.2;
    _timeFormWidth = AppSize.of(context).safeBlockHorizontal * 20;
    _timeFormDistance = AppSize.of(context).safeBlockHorizontal * 10;
    _levelContentWidth = AppSize.of(context).safeBlockHorizontal * 23;
    _countContentWidth = AppSize.of(context).safeBlockHorizontal * 18;
    _circleButtonSize = AppSize.of(context).safeBlockHorizontal * 5;
    _buttonWidth = AppSize.of(context).safeBlockHorizontal * 80;
    _buttonHeight = AppSize.of(context).safeBlockHorizontal * 12;
  }

  Container _buildDragHandle() {
    return Container(
      width: AppSize.of(context).safeBlockHorizontal * 13,
      height: AppSize.of(context).safeBlockVertical * 0.5,
      decoration: BoxDecoration(
        color: AppColors.greyMedium,
        borderRadius:
            BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 3),
      ),
    );
  }

  Container _buildLabel(String label) {
    final double labelWidth = _labelWidth;
    final double labelHeight = _labelHeight;
    return Container(
      width: labelWidth,
      height: labelHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(left: AppSize.of(context).safeBlockHorizontal * 13),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
          ).copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildCreateRecordForm() {
    final double contentLeftPadding =
        AppSize.of(context).safeBlockHorizontal * 10;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabel("지점"),
              Container(
                width: _contentWidth,
                height: _contentHeight,
                padding: EdgeInsets.only(
                  right: contentLeftPadding,
                ),
                child: _GenericDropdown<Location>(
                  values: Location.values,
                  toName: Location.toName,
                  selectedValue: _selectedLocation,
                  onChanged: _changeLocation,
                  hintText: "지점을 선택해주세요",
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabel("시간"),
              _TimeForm(
                width: _timeFormWidth,
                height: _contentHeight,
                initialTime: _startTime,
                onChanged: (time) {
                  setState(() {
                    _startTime = time;
                  });
                },
                borderColor: _endTime.compareTo(_startTime) > 0
                    ? AppColors.greyMediumDark
                    : AppColors.redMedium,
              ),
              SizedBox(
                width: _timeFormDistance,
                child: Align(
                    child: Text(
                  "~",
                  style: GoogleFonts.roboto().copyWith(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 4.5,
                    color: AppColors.greyMedium,
                  ),
                )),
              ),
              _TimeForm(
                width: _timeFormWidth,
                height: _contentHeight,
                initialTime: _endTime,
                onChanged: (time) {
                  setState(() {
                    _endTime = time;
                  });
                },
                borderColor: _endTime.compareTo(_startTime) > 0
                    ? AppColors.greyMediumDark
                    : AppColors.redMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("완등한 문제"),
              Column(
                children: _buildBoulderProblemFormList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeLocation(Location? location) {
    setState(() {
      _selectedLocation = location!;
    });
  }

  List<Widget> _buildBoulderProblemFormList() {
    final double contentLeftPadding =
        AppSize.of(context).safeBlockHorizontal * 10;
    return List.generate(
      _boulderProblems.length,
      (index) {
        return Container(
          width: _contentWidth,
          height: _labelHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            right: contentLeftPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBoulderProblemDropdown(index),
              _buildCountDropdown(index),
              index == (_boulderProblems.length - 1)
                  ? _buildPlusButton()
                  : _buildMinusButton(index),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBoulderProblemDropdown(int index) {
    return SizedBox(
      width: _levelContentWidth,
      height: _contentHeight,
      child: _GenericDropdown<BoulderLevel>(
        values: BoulderLevel.values,
        toName: BoulderLevel.toName,
        selectedValue: _boulderProblems[index].level,
        onChanged: (level) {
          setState(() {
            _boulderProblems[index] =
                (level: level, count: _boulderProblems[index].count);
          });
        },
        hintText: "난이도",
      ),
    );
  }

  Widget _buildCountDropdown(int index) {
    return SizedBox(
      width: _countContentWidth,
      height: _contentHeight,
      child: _CountDropdown(
        selectedValue: _boulderProblems[index].count,
        onChanged: (count) {
          setState(
            () {
              _boulderProblems[index] =
                  (level: _boulderProblems[index].level, count: count);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlusButton() {
    return _buildCircleButton(
      'assets/icons/plus_circle.svg',
      () {
        setState(() {
          _boulderProblems.add((level: null, count: null));
        });
      },
    );
  }

  Widget _buildMinusButton(int index) {
    return _buildCircleButton(
      'assets/icons/minus_circle.svg',
      () {
        setState(() {
          _boulderProblems.removeAt(index);
        });
      },
    );
  }

  Widget _buildCircleButton(String iconPath, VoidCallback onPressed) {
    return Container(
      width: _circleButtonSize * 1.2,
      height: _circleButtonSize * 1.2,
      alignment: Alignment.center,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: SvgPicture.asset(
          iconPath,
          width: _circleButtonSize,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: _onPressedUpdateRecord,
      ),
    );
  }

  void _onPressedUpdateRecord() {
    if (_hasEmptyField()) {
      ToastHelper.show(context, "모든 항목을 입력해주세요.");
      return;
    }
    if (_hasDuplicateBoulderLevel()) {
      ToastHelper.show(context, "중복되는 난이도가 있어요.");
      return;
    }
    if (_endTimeIsBeforeStartTime()) {
      ToastHelper.show(context, "종료 시간이 시작 시간보다 빨라요.\n당신은 시간의 마술사?");
      return;
    }
    if (_endTimeIsAfterCurrentTime()) {
      ToastHelper.show(context, "종료 시간이 현재 시간보다 늦어요.\n당신은 시간의 마술사?");
      return;
    }
    widget.updateRecord(
      RecordState(
        id: widget.recordState.id,
        location: _selectedLocation,
        startTime: widget.recordState.startTime.copyWith(
          hour: _startTime.hour,
          minute: _startTime.minute,
        ),
        endTime: widget.recordState.endTime.copyWith(
          hour: _endTime.hour,
          minute: _endTime.minute,
        ),
        boulderProblems:
            List<({BoulderLevel level, int count})>.from(_boulderProblems),
      ),
    );
  }

  bool _hasEmptyField() {
    for (final boulderProblem in _boulderProblems) {
      if (boulderProblem.level == null || boulderProblem.count == null) {
        return true;
      }
    }
    return false;
  }

  bool _hasDuplicateBoulderLevel() {
    final List<BoulderLevel?> levels =
        _boulderProblems.map((e) => e.level).toList();
    return levels.toSet().length != levels.length;
  }

  bool _endTimeIsBeforeStartTime() {
    return _endTime.compareTo(_startTime) <= 0;
  }

  bool _endTimeIsAfterCurrentTime() {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.now();
    if (widget.recordState.endTime.year != currentDate.year) {
      return widget.recordState.endTime.year > currentDate.year;
    }
    if (widget.recordState.endTime.month != currentDate.month) {
      return widget.recordState.endTime.month > currentDate.month;
    }
    if (widget.recordState.endTime.day != currentDate.day) {
      return widget.recordState.endTime.day > currentDate.day;
    }
    return _endTime.compareTo(currentTime) > 0;
  }
}

/// Generic 드롭다운 위젯
class _GenericDropdown<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Map<T, String> toName;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String hintText;

  _GenericDropdown({
    super.key,
    required this.values,
    required this.toName,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            hintText,
            style: GoogleFonts.roboto(
              fontSize: (AppSize.of(context).safeBlockHorizontal * 3.0),
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: values.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                toName[value] ?? "error42",
                style: GoogleFonts.roboto(
                  fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                  color: Color(0xFF4E5055),
                ),
              ),
            );
          }).toList(),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            width: double.maxFinite,
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: AppSize.of(context).safeBlockHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFD1D3D9),
              ),
              borderRadius: BorderRadius.circular(
                  AppSize.of(context).safeBlockHorizontal * 2),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: AppSize.of(context).safeBlockHorizontal * 5,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: AppSize.of(context).safeBlockVertical * 25,
            width: AppSize.of(context).safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  AppSize.of(context).safeBlockHorizontal * 3),
              color: Color(0xFFFFFFFF),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.only(
              left: AppSize.of(context).safeBlockHorizontal * 3,
            ),
          ),
        ),
      ),
    );
  }
}

/// 시간 선택 폼 위젯
class _TimeForm extends StatefulWidget {
  final double width;
  final double height;
  final TimeOfDay initialTime;
  final void Function(TimeOfDay) onChanged;
  final Color borderColor;

  const _TimeForm({
    required this.width,
    required this.height,
    required this.initialTime,
    required this.onChanged,
    this.borderColor = const Color(0xFFD1D3D9),
  });

  @override
  State<_TimeForm> createState() => _TimeFormState();
}

class _TimeFormState extends State<_TimeForm> {
  late Color borderColor;
  late TimeOfDay selectedTime = widget.initialTime;

  @override
  void initState() {
    super.initState();
    borderColor = widget.borderColor;
  }

  @override
  void didUpdateWidget(covariant _TimeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    borderColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onTap: () async {
          final TimeOfDay? timeOfDay = await _showTimePicker();
          if (timeOfDay != null) {
            setState(() {
              selectedTime = timeOfDay;
            });
            widget.onChanged(selectedTime);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(
              AppSize.of(context).safeBlockHorizontal * 2,
            ),
          ),
          child: Text(
            "${selectedTime.hour}:${selectedTime.minute < 10 ? "0" : ""}${selectedTime.minute}",
            style: GoogleFonts.roboto(
              fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
              color: Color(0xFF4E5055),
            ),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker() async {
    return await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              // change the text color
              onSurface: AppColors.greyDark,
              background: Colors.white,
              outline: AppColors.greyDark,
            ),
            // button colors
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

class _CountDropdown extends StatelessWidget {
  final int? selectedValue;
  final void Function(int?) onChanged;
  _CountDropdown({
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            "개수",
            style: GoogleFonts.roboto(
              fontSize: AppSize.of(context).safeBlockHorizontal * 3.0,
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: List.generate(
            100,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                "${index + 1}",
                style: GoogleFonts.roboto(
                  fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                  color: Color(0xFF4E5055),
                ),
              ),
            ),
          ),
          value: selectedValue,
          onChanged: onChanged,
          style: GoogleFonts.roboto(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            color: Colors.black,
          ),
          buttonStyleData: ButtonStyleData(
            width: double.maxFinite,
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: AppSize.of(context).safeBlockHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFD1D3D9),
              ),
              borderRadius: BorderRadius.circular(
                AppSize.of(context).safeBlockHorizontal * 2,
              ),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: AppSize.of(context).safeBlockHorizontal * 5,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: AppSize.of(context).safeBlockVertical * 25,
            width: AppSize.of(context).safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppSize.of(context).safeBlockHorizontal * 3,
              ),
              color: Color(0xFFFFFFFF),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.only(
              left: AppSize.of(context).safeBlockHorizontal * 3,
            ),
          ),
        ),
      ),
    );
  }
}
