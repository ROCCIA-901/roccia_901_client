import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mvvm_riverpod/viewmodel_builder.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/constants/app_enum.dart';
import 'package:untitled/constants/size_config.dart';
import 'package:untitled/presentation/screens/my_page/my_page_header.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_common_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_loading_overlay.dart';
import '../../../utils/app_router.dart';
import '../../viewmodels/authentication/logout_viewmodel.dart';
import '../../viewmodels/user/my_page_view_model.dart';

@RoutePage()
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder(
        provider: myPageViewModelProvider,
        onDispose: _onDispose,
        onEventEmitted: _onEventEmitted,
        builder: _builder,
      ),
    );
  }

  void _onDispose() {
    AppLoadingOverlay.hide();
  }

  void _onEventEmitted(
    BuildContext context,
    MyPageViewModel model,
    MyPageEvent event,
  ) {
    switch (event) {
      case MyPageEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case MyPageEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case MyPageEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case MyPageEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const MyPageRoute());
        }));
    }
  }

  Widget _builder(BuildContext context, MyPageViewModel model) {
    return RefreshIndicator(
      onRefresh: () async {
        model.refresh();
      },
      child: SafeArea(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            _MyPageAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  MyPageHeader(
                    profileImagePath: model.myPageState?.profileImage ?? "assets/profiles/profile_0.svg",
                    introduction: model.myPageState?.introduction ?? "",
                  ),
                  switch (model.myPageState) {
                    null => Container(
                        width: double.infinity,
                        height: AppSize.of(context).safeBlockHorizontal * 100.0,
                        child: Center(
                          child: LoadingAnimationWidget.threeRotatingDots(
                            color: AppColors.primary,
                            size: AppSize.of(context).safeBlockHorizontal * 10.0,
                          ),
                        ),
                      ),
                    _ => Column(
                        children: [
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              _TableTitle(title: "프로필"),
                              Positioned(
                                left: AppSize.of(context).safeBlockHorizontal * 22,
                                top: AppSize.of(context).safeBlockHorizontal * 0.5,
                                child: _OpenUpdateFormButton(myPageState: model.myPageState!),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _TableContents(contents: model.myPageState!.profile),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _HorizontalLine(),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _TableTitle(title: "내 출석"),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _TableContents(contents: model.myPageState!.attendanceInfo),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _HorizontalLine(),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.of(context).safeBlockHorizontal * 8,
                            ),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: AppSize.of(context).font.headline3,
                                  color: AppColors.greyDark,
                                ),
                                children: [
                                  TextSpan(
                                    text: "나의 총 운동 시간   ",
                                  ),
                                  TextSpan(
                                    text: "${model.myPageState!.totalWorkoutTime ~/ 60}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 시간  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${model.myPageState!.totalWorkoutTime % 60}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 분",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _TableTitle(title: "내 기록"),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _TableContents(contents: model.myPageState!.boulders),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                          _ReportButton(),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 3),
                          _VersionText(),
                          SizedBox(height: AppSize.of(context).safeBlockHorizontal * 3),
                        ],
                      ),
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppSize.of(context).safeBlockHorizontal * 12;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryLight,
      surfaceTintColor: AppColors.primaryLight,
      elevation: 1,
      shadowColor: Colors.grey,
      toolbarHeight: appBarHeight,
      pinned: false,
      floating: false,
      title: Text(
        "마이페이지",
        style: TextStyle(
          fontSize: AppSize.of(context).font.title,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _LogOutButton(),
      ],
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: AppSize.of(context).safeBlockHorizontal * 3.5,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return _LogOutPopUp();
            },
          );
        },
        child: SvgPicture.asset(
          'assets/icons/my_page_logout.svg',
          height: AppSize.of(context).safeBlockHorizontal * 5,
          color: AppColors.greyMediumDark,
        ),
      ),
    );
  }
}

class _LogOutPopUp extends ConsumerWidget {
  _LogOutPopUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double popUpWidth = AppSize.of(context).safeBlockHorizontal * 85;
    final double popUpHeight = AppSize.of(context).safeBlockHorizontal * 35;
    final double yesButtonWidth = popUpWidth * 0.2;
    final double noButtonWidth = popUpWidth * 0.3;
    final double buttonHeight = popUpWidth * 0.1;

    return Dialog(
      child: Container(
        width: popUpWidth,
        height: popUpHeight,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.of(context).safeBlockHorizontal * 5,
          vertical: AppSize.of(context).safeBlockHorizontal * 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppSize.of(context).safeBlockHorizontal * 5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: popUpWidth * 0.05),
            Text(
              "로그아웃 하시겠습니까?",
              style: TextStyle(
                fontSize: AppSize.of(context).font.headline2,
                color: Colors.black,
              ),
            ),
            SizedBox(height: popUpWidth * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: noButtonWidth,
                  height: buttonHeight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '아니오',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: AppSize.of(context).font.headline2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: yesButtonWidth,
                  height: buttonHeight,
                  child: TextButton(
                    onPressed: () {
                      ref.read(logOutControllerProvider.notifier).execute();
                      AutoRouter.of(context).popUntilRoot();
                      AutoRouter.of(context).replace(LoginRoute());
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: AppSize.of(context).font.headline2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TableTitle extends StatelessWidget {
  final String title;

  _TableTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(flex: 8),
        Expanded(
          flex: 92,
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.of(context).font.headline3,
              color: AppColors.greyDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _TableContents extends StatelessWidget {
  final MyPageTableContents contents;

  _TableContents({
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: contents
          .map(
            (e) => Container(
              margin: EdgeInsets.symmetric(
                vertical: AppSize.of(context).safeBlockHorizontal * 1,
              ),
              child: Row(
                children: [
                  Spacer(flex: 8),
                  Expanded(
                    flex: 24,
                    child: Text(
                      e.field,
                      style: TextStyle(
                        fontSize: AppSize.of(context).font.headline3,
                        color: AppColors.greyDark,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 68,
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: AppSize.of(context).font.headline3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyLight,
      width: double.infinity,
      height: AppSize.of(context).safeBlockHorizontal * 0.5,
    );
  }
}

class _ReportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = AppSize.of(context).safeBlockHorizontal * 90;
    final double height = AppSize.of(context).safeBlockHorizontal * 10;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: max(
          (AppSize.of(context).safeBlockHorizontal * 100 - width) / 2,
          0,
        ),
      ),
      child: AppCommonTextButton(
        text: Text(
          "오류 제보",
          style: TextStyle(
            fontSize: AppSize.of(context).font.headline3,
            color: Colors.white,
          ),
        ),
        onPressed: () async => await launchUrl(Uri.parse(AppConstants.reportUrl)),
        backgroundColor: AppColors.redMedium,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: width,
        height: height,
      ),
    );
  }
}

class _VersionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: AppSize.of(context).safeBlockHorizontal * 5,
      ),
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Text(
        "Ver ${AppConstants.version}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppSize.of(context).font.headline3,
          color: AppColors.greyMediumDark,
        ),
      ),
    );
  }
}

class _OpenUpdateFormButton extends StatelessWidget {
  final MyPageState myPageState;

  _OpenUpdateFormButton({
    required this.myPageState,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.edit,
        color: AppColors.greyMediumDark,
        size: AppSize.of(context).safeBlockHorizontal * 5,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              child: _UpdateProfileForm(
                initialProfile: ProfileUpdateState(
                  location: myPageState.location,
                  level: myPageState.level,
                  profileImageNumber: myPageState.profileImageNumber,
                  introduction: myPageState.introduction,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _UpdateProfileForm extends ConsumerStatefulWidget {
  final ProfileUpdateState initialProfile;
  const _UpdateProfileForm({
    super.key,
    required this.initialProfile,
  });

  @override
  ConsumerState<_UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends ConsumerState<_UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();

  /// Form 입력 값을 저장하는 변수들.
  late String _introduction; // 소개

  /// Dropdown Button2에서 선택된 값들(package 이름이 button2 입니다.)
  // 선택되지 않은 초기값은 null
  Location? _location; // 운동 지점
  BoulderLevel? _level; // 운동 난이도

  /// 선택된 프로필
  int? _profileIndex;

  late ProfileUpdateState profile = widget.initialProfile;

  @override
  void initState() {
    super.initState();

    _location = profile.location;
    _level = profile.level;
    _profileIndex = (profile.profileImageNumber ?? 1) - 1;
    _introduction = profile.introduction ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.of(context).safeBlockHorizontal * 85,
      height: AppSize.of(context).safeBlockVertical * 70,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 5,
        vertical: AppSize.of(context).safeBlockHorizontal * 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppSize.of(context).safeBlockHorizontal * 3,
        ),
        border: Border.all(
          width: AppSize.of(context).safeBlockHorizontal * 0.5,
          color: AppColors.greyMedium,
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 운동 지점 label
              _FormTitle(title: '운동 지점'),
              GenericDropdown(
                values: Location.values.sublist(0, AppConstants.workoutLocationCount),
                toName: Location.toName,
                selectedValue: _location,
                onChanged: changeLocation,
                hintText: "본인의 운동 지점을 선택해 주세요.",
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 운동 난이도 label
              _FormTitle(title: '운동 난이도'),
              GenericDropdown(
                values: BoulderLevel.values,
                toName: BoulderLevel.toName,
                selectedValue: _level,
                onChanged: changeLevel,
                hintText: "본인의 볼더링 난이도를 선택해 주세요.(더클라임 기준)",
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 프로필 label
              _FormTitle(title: '프로필'),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: AppSize.of(context).safeBlockHorizontal * 0.5,
                ),
                margin: EdgeInsets.only(bottom: AppSize.of(context).safeBlockVertical * 1.5),
                child: Text(
                  "프로필로 사용할 이미지를 선택해 주세요.",
                  style: GoogleFonts.roboto(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 4,
                    color: Color(0xFFD1D3D9),
                  ),
                ),
              ),
              ProfileSelection(
                selectedProfileIndex: _profileIndex,
                onTap: changeProfileIndex,
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 소개 label
              _FormTitle(title: '소개'),
              // 소개 입력 필드
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: TextFormField(
                  initialValue: _introduction,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLength: 300,
                  maxLines: 7,
                  cursorOpacityAnimates: true,
                  style: GoogleFonts.roboto(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '본인 소개 글을 작성해 주세요.(300자 이하)',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                      color: Color(0xFFD1D3D9),
                    ),
                    errorStyle: TextStyle(
                      height: 0.01,
                      color: Colors.transparent,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSize.of(context).safeBlockHorizontal * 3,
                      vertical: AppSize.of(context).safeBlockHorizontal * 2.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Color(0xFFD1D3D9),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Color(0xFFD1D3D9),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                  },
                  onSaved: (value) {
                    _introduction = value ?? "";
                  },
                ),
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 3.7),
              AppCommonTextButton(
                text: Text(
                  "수정하기",
                  style: TextStyle(
                    fontSize: AppSize.of(context).font.headline3,
                    color: Colors.white,
                  ),
                ),
                onPressed: _updateProfile,
                backgroundColor: AppColors.primary,
                cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
                width: AppSize.of(context).safeBlockHorizontal * 80,
                height: AppSize.of(context).safeBlockHorizontal * 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(myPageViewModelProvider.notifier).updateProfile(
            profile: ProfileUpdateState(
              location: _location,
              level: _level,
              profileImageNumber: _profileIndex! + 1,
              introduction: _introduction,
            ),
          );
      Navigator.pop(context);
      return;
    }
    ToastHelper.show(context, "소개란은 빈 칸일 수 없습니다.");
  }

  /// 프로필 선택 callback
  void changeProfileIndex(int index) {
    setState(() {
      _profileIndex = index;
    });
  }

  void changeLocation(Location? location) {
    setState(() {
      _location = location;
    });
  }

  void changeLevel(BoulderLevel? level) {
    setState(() {
      _level = level;
    });
  }
}

/// Generic 드롭다운 위젯
class GenericDropdown<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Map<T, String> toName;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String hintText;
  final bool doValidate;

  late final Color borderColor;

  GenericDropdown({
    super.key,
    required this.values,
    required this.toName,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.doValidate = false,
  }) {
    if (doValidate && selectedValue == null) {
      borderColor = Colors.red;
    } else {
      borderColor = AppColors.greyMediumDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    T selectedValue = this.selectedValue ?? values.first;
    if (values.contains(selectedValue) == false) {
      selectedValue = values.first;
    }
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            hintText,
            style: GoogleFonts.roboto(
              fontSize: (hintText.length > 25
                  ? AppSize.of(context).safeBlockHorizontal * 3.0
                  : AppSize.of(context).safeBlockHorizontal * 3.5),
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
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: AppSize.of(context).safeBlockHorizontal * 7,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: AppSize.of(context).safeBlockVertical * 25,
            width: AppSize.of(context).safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
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

/// 프로필 선택 위젯
class ProfileSelection extends StatelessWidget {
  final int? selectedProfileIndex; // 처음엔 아무 프로필도 선택되어 있지 않는다.
  final void Function(int) onTap;

  ProfileSelection({
    super.key,
    required this.selectedProfileIndex,
    required this.onTap,
  });

  final List<String> profileUrls = List.generate(8, (index) => 'assets/profiles/profile_${index + 1}.svg');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: AppSize.of(context).safeBlockHorizontal * 2.2,
        children: List.generate(
          profileUrls.length,
          (index) => InkResponse(
            onTap: () {
              onTap(index);
            },
            splashFactory: NoSplash.splashFactory,
            child: Container(
              width: AppSize.of(context).safeBlockHorizontal * 15,
              height: AppSize.of(context).safeBlockHorizontal * 15,
              padding: EdgeInsets.all(AppSize.of(context).safeBlockHorizontal * 0.667),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedProfileIndex == index ? Color(0xFFB1E2B6) : Color(0xFFE9E9E9),
                  width: AppSize.of(context).safeBlockHorizontal * 1,
                ),
              ),
              child: SvgPicture.asset(
                'assets/profiles/profile_${index + 1}.svg',
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormTitle extends StatelessWidget {
  final String title;

  _FormTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: AppSize.of(context).safeBlockHorizontal * 1.5,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppSize.of(context).font.headline3,
          color: AppColors.greyDark,
        ),
      ),
    );
  }
}
