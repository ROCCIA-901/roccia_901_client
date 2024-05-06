import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/presentation/screens/shared/exception_handler_on_view.dart';
import 'package:untitled/presentation/viewmodels/authentication/register_viewmodel.dart';
import 'package:untitled/utils/app_router.dart';
import 'package:untitled/utils/dialog_helper.dart';
import 'package:untitled/utils/snack_bar_helper.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_enum.dart';
import '../../constants/size_config.dart';
import '../../utils/countdown_timer.dart';
import '../../widgets/app_common_text_button.dart';

// Todo 드롭다운 메뉴 확장 시 화면 스크롤 안되는 문제 해결
// Todo Timer Logic이 UI에 종속되어 있음. Timer Logic을 분리하자.

@RoutePage()
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _authCodeFormKey = GlobalKey<FormState>();
  final _otherFormKey = GlobalKey<FormState>();

  /// Form 입력 값을 저장하는 변수들.
  late String _email; // 이메일
  late String _authenticationCode; // 인증번호
  late String _password; // 비밀번호
  late String _passwordConfirm; // 비밀번호 확인
  late String _name; // 이름
  late String _introduction; // 소개

  // 인증번호 요청 버튼이 눌렸는지
  bool _isRequestAuthCodePressed = false;
  // email이 인증되었는지
  bool _isEmailVerified = false;

  /// Dropdown Button2에서 선택된 값들(package 이름이 button2 입니다.)
  // 선택되지 않은 초기값은 null
  int? _generation; // 기수
  UserRole? _userRole; // 역할
  Location? _location; // 운동 지점
  BoulderLevel? _level; // 운동 난이도

  /// 선택된 프로필
  int? _profileIndex;

  /// 인증 타임아웃 카운트다운을 위한 변수
  late int _currentCount; // 화면에 표시되는 현재 카운트
  late CountdownTimer _countdownTimer;

  /// 제출을 한번이라도 시도 했는지
  bool _hasTriedSubmit = false;

  @override
  void initState() {
    super.initState();
    _currentCount = AppConstants.authenticationTimeOut;
    _countdownTimer = CountdownTimer(
      duration: AppConstants.authenticationTimeOut,
      onTick: decreaseCount,
      onDone: () {},
    );
  }

  @override
  void dispose() {
    // 화면을 나갈 때 타이머 종료.
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setListener();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/titles/sign_up_title.svg',
            color: Color(0xFF000000),
            width: AppSize.of(context).safeBlockHorizontal * 25.28,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.of(context).safeBlockHorizontal * 7,
            vertical: AppSize.of(context).safeBlockVertical * 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 이메일 label
              InputLabel(label: '이메일'),

              /// 이메일 입력 필드 & 인증번호 받기 버튼
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  bottom: AppSize.of(context).safeBlockVertical * 0.7,
                ),
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// 이메일 입력 필드
                      Form(
                        key: _emailFormKey,
                        child: SizedBox(
                          width:
                              AppSize.of(context).safeBlockHorizontal * 55.56,
                          child: TextFormField(
                            readOnly:
                                _isRequestAuthCodePressed || _isEmailVerified,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            style: GoogleFonts.roboto(
                              fontSize:
                                  AppSize.of(context).safeBlockHorizontal * 3.5,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: '이메일을 입력해주세요.',
                              labelStyle: GoogleFonts.roboto(
                                fontSize:
                                    AppSize.of(context).safeBlockHorizontal *
                                        3.3,
                                color: Color(0xFFD1D3D9),
                              ),
                              errorStyle: TextStyle(
                                height: 0.01,
                                color: Colors.transparent,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    AppSize.of(context).safeBlockHorizontal * 3,
                                vertical: 0,
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
                              if (!EmailValidator.validate(value ?? "")) {
                                SnackBarHelper.showTextSnackBar(
                                    context, "이메일 형식이 올바르지 않습니다.");
                                return '';
                              }
                            },
                            onSaved: (value) {
                              _email = value ?? "";
                            },
                          ),
                        ),
                      ),

                      /// 인증번호 받기 버튼
                      GetAuthenticationButton(
                        firstOnPressed: () {
                          _countdownTimer.start();
                          _requestRegisterAuthCode();
                        },
                        secondOnPressed: () {
                          setState(() {
                            _currentCount = AppConstants.authenticationTimeOut;
                          });
                          _countdownTimer.restart();
                          _requestRegisterAuthCode();
                        },
                        enabled: !_isEmailVerified,
                      ),
                    ],
                  ),
                ),
              ),

              /// 인증 번호 입력 필드 & 인증번호 확인 버튼
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// 인증번호 입력 필드
                      Form(
                        key: _authCodeFormKey,
                        child: SizedBox(
                          width:
                              AppSize.of(context).safeBlockHorizontal * 55.56,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              TextFormField(
                                readOnly: _isEmailVerified,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      AppSize.of(context).safeBlockHorizontal *
                                          3.5,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    height: 0.01,
                                    color: Colors.transparent,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppSize.of(context)
                                            .safeBlockHorizontal *
                                        3,
                                    vertical: 0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD1D3D9),
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
                                    SnackBarHelper.showTextSnackBar(
                                        context, "인증번호를 입력해주세요.");
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  _authenticationCode = value ?? "";
                                },
                              ),
                              // 카운트 다운 타이머
                              Positioned(
                                top: AppSize.of(context).safeBlockHorizontal *
                                    3.2,
                                right: AppSize.of(context).safeBlockHorizontal *
                                    3.2,
                                child: Text(
                                  "${(_currentCount / 60).floor()}:${(_currentCount % 60).toString().padLeft(2, '0')}",
                                  style: GoogleFonts.roboto(
                                    fontSize: AppSize.of(context)
                                            .safeBlockHorizontal *
                                        3.5,
                                    color: Color(0xFFD1D3D9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// 인증번호 확인 버튼
                      SizedBox(
                        width: AppSize.of(context).safeBlockHorizontal * 27.78,
                        child: AppCommonTextButton(
                          text: Text(
                            '인증번호 확인',
                            style: GoogleFonts.inter(
                              fontSize:
                                  AppSize.of(context).safeBlockHorizontal * 4.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          backgroundColor: _isEmailVerified
                              ? AppColors.greyLight
                              : Theme.of(context).colorScheme.primary,
                          cornerRadius: 6,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          onPressed: () {
                            if (_isEmailVerified) {
                              return;
                            }
                            _verifyRegisterAuthCode();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              Form(
                key: _otherFormKey,
                child: Column(
                  children: [
                    /// 비밀번호 label
                    InputLabel(label: '비밀번호'),
                    // 비밀번호 입력 필드
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 31 / 4,
                        child: TextFormField(
                          // 비밀번호 입력이므로 TextInputType.text 사용
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          // 비밀번호 입력을 위한 설정들
                          obscureText: true, // 비밀번호 숨김 처리
                          enableSuggestions: false, // 제안 비활성화
                          autocorrect: false, // 자동 검사 비활성화
                          style: GoogleFonts.roboto(
                            fontSize:
                                AppSize.of(context).safeBlockHorizontal * 3.5,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: '영문, 숫자, 특수문자를 포함하여 7자 이상 입력해 주세요.',
                            labelStyle: GoogleFonts.roboto(
                              fontSize:
                                  AppSize.of(context).safeBlockHorizontal * 3.2,
                              color: Color(0xFFD1D3D9),
                            ),
                            errorStyle: TextStyle(
                              height: 0.01,
                              color: Colors.transparent,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  AppSize.of(context).safeBlockHorizontal * 3,
                              vertical: 0,
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
                            _password = value ?? "";
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 비밀번호 확인 label
                    InputLabel(label: '비밀번호 확인'),
                    // 비밀번호 확인 입력 필드
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 31 / 4,
                        child: TextFormField(
                          // 비밀번호 입력이므로 TextInputType.text 사용
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          // 비밀번호 입력을 위한 설정들
                          obscureText: true, // 비밀번호 숨김 처리
                          enableSuggestions: false, // 제안 비활성화
                          autocorrect: false, // 자동 검사 비활성화
                          style: GoogleFonts.roboto(
                            fontSize:
                                AppSize.of(context).safeBlockHorizontal * 3.5,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: '비밀번호를 다시 한번 입력해주세요.',
                            labelStyle: GoogleFonts.roboto(
                              fontSize:
                                  AppSize.of(context).safeBlockHorizontal * 3.5,
                              color: Color(0xFFD1D3D9),
                            ),
                            errorStyle: TextStyle(
                              height: 0.01,
                              color: Colors.transparent,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  AppSize.of(context).safeBlockHorizontal * 3,
                              vertical: 0,
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
                            _passwordConfirm = value ?? "";
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 이름 label
                    InputLabel(label: '이름'),
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 31 / 4,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.roboto(
                            fontSize:
                                AppSize.of(context).safeBlockHorizontal * 3.5,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: '본인 이름을 입력해 주세요.',
                            labelStyle: GoogleFonts.roboto(
                              fontSize:
                                  AppSize.of(context).safeBlockHorizontal * 3.5,
                              color: Color(0xFFD1D3D9),
                            ),
                            errorStyle: TextStyle(
                              height: 0.01,
                              color: Colors.transparent,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  AppSize.of(context).safeBlockHorizontal * 3,
                              vertical:
                                  AppSize.of(context).safeBlockHorizontal * 2.0,
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
                            _name = value ?? "";
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 기수 label
                    InputLabel(label: '기수'),
                    GenerationDropdown(
                      selectedValue: _generation,
                      onChanged: changeGeneration,
                      doValidate: _hasTriedSubmit,
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 역할 label
                    InputLabel(label: '역할'),
                    GenericDropdown(
                      values: UserRole.values,
                      toName: UserRole.toName,
                      selectedValue: _userRole,
                      onChanged: changeRole,
                      hintText: "본인의 역할을 선택해 주세요.",
                      doValidate: _hasTriedSubmit,
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 운동 지점 label
                    InputLabel(label: '운동 지점'),
                    GenericDropdown(
                      values: Location.values
                          .sublist(0, AppConstants.workoutLocationCount),
                      toName: Location.toName,
                      selectedValue: _location,
                      onChanged: changeLocation,
                      hintText: "본인의 운동 지점을 선택해 주세요.",
                      doValidate: _hasTriedSubmit,
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 운동 난이도 label
                    InputLabel(label: '운동 난이도'),
                    GenericDropdown(
                      values: BoulderLevel.values,
                      toName: BoulderLevel.toName,
                      selectedValue: _level,
                      onChanged: changeLevel,
                      hintText: "본인의 볼더링 난이도를 선택해 주세요.(더클라임 기준)",
                      doValidate: _hasTriedSubmit,
                    ),
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 프로필 label
                    InputLabel(label: '프로필'),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                        left: AppSize.of(context).safeBlockHorizontal * 0.5,
                      ),
                      margin: EdgeInsets.only(
                          bottom: AppSize.of(context).safeBlockVertical * 1.5),
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
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 4.7),

                    /// 소개 label
                    InputLabel(label: '소개'),
                    // 소개 입력 필드
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLength: 300,
                        maxLines: 7,
                        cursorOpacityAnimates: true,
                        style: GoogleFonts.roboto(
                          fontSize:
                              AppSize.of(context).safeBlockHorizontal * 3.5,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '본인 소개 글을 작성해 주세요.(300자 이하)',
                          hintStyle: GoogleFonts.roboto(
                            fontSize:
                                AppSize.of(context).safeBlockHorizontal * 3.5,
                            color: Color(0xFFD1D3D9),
                          ),
                          errorStyle: TextStyle(
                            height: 0.01,
                            color: Colors.transparent,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                AppSize.of(context).safeBlockHorizontal * 3,
                            vertical:
                                AppSize.of(context).safeBlockHorizontal * 2.0,
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
                    SizedBox(
                        height: AppSize.of(context).safeBlockVertical * 3.7),
                  ],
                ),
              ),

              /// 가입하기 버튼
              AspectRatio(
                aspectRatio: 31 / 4,
                child: AppCommonTextButton(
                  text: Text(
                    '가입하기',
                    style: GoogleFonts.inter(
                      fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  cornerRadius: 6,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  onPressed: () {
                    _submitResisterForm();
                  },
                ),
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 1.0),
            ],
          ),
        ),
      ),
    );
  }

  /// Dropdown Button2 위젯들에서 사용할 callback 함수들
  void changeGeneration(int? generation) {
    setState(() {
      _generation = generation;
    });
  }

  void changeRole(UserRole? userRole) {
    setState(() {
      _userRole = userRole;
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

  /// 프로필 선택 callback
  void changeProfileIndex(int index) {
    setState(() {
      _profileIndex = index;
    });
  }

  /// 카운트다운 초당 callback 함수
  void decreaseCount() {
    setState(() {
      if (_currentCount > 0) {
        _currentCount--;
      }
    });
  }

  void _requestRegisterAuthCode() {
    if (!_isRequestAuthCodePressed) {
      if (!(_emailFormKey.currentState!.validate())) {
        return;
      }
      _emailFormKey.currentState?.save();
    }
    ref
        .read(requestRegisterAuthCodeControllerProvider.notifier)
        .execute(email: _email);
  }

  void _verifyRegisterAuthCode() {
    if (!(_emailFormKey.currentState!.validate()) ||
        !(_authCodeFormKey.currentState!.validate())) {
      return;
    }
    if (!_isRequestAuthCodePressed) {
      SnackBarHelper.showTextSnackBar(context, "인증번호를 받아주세요.");
      return;
    }
    _authCodeFormKey.currentState?.save();
    ref
        .read(verifyRegisterAuthCodeControllerProvider.notifier)
        .execute(email: _email, authCode: _authenticationCode);
  }

  void _submitResisterForm() {
    setState(() {
      _hasTriedSubmit = true;
    });
    final isEmailValid = _emailFormKey.currentState?.validate();
    final isFormValid = _otherFormKey.currentState?.validate();

    if (!_isEmailVerified) {
      SnackBarHelper.showTextSnackBar(context, "이메일 인증을 완료해주세요.");
      return;
    }
    if (_emailFormKey.currentState == null || isEmailValid != true) {
      SnackBarHelper.showTextSnackBar(context, "이메일 형식이 올바르지 않습니다.");
      return;
    }
    if (_otherFormKey.currentState == null || isFormValid != true) {
      SnackBarHelper.showTextSnackBar(context, "비어있는 항목이 있습니다.");
      return;
    }
    if (_generation == null ||
        _userRole == null ||
        _location == null ||
        _level == null) {
      SnackBarHelper.showTextSnackBar(context, "필수 항목을 선택해주세요.");
      return;
    }
    if (_profileIndex == null) {
      SnackBarHelper.showTextSnackBar(context, "프로필을 선택해주세요.");
      return;
    }
    _otherFormKey.currentState?.save();
    ref.read(registerControllerProvider.notifier).execute(
          email: _email,
          password: _password,
          passwordConfirm: _passwordConfirm,
          username: _name,
          generation: "$_generation기",
          role: UserRole.toName[_userRole]!,
          workoutLocation: Location.toName[_location]!,
          workoutLevel: BoulderLevel.toName[_level]!,
          profileNumber: _profileIndex! + 1,
          introduction: _introduction,
        );
  }

  // ------------------------------------------------------------------------ //
  // Notification Listeners                                                   //
  // ------------------------------------------------------------------------ //
  void _setListener() {
    _listenRequestAuthCode();
    _listenEmailValidation();
    _listenRegister();
  }

  void _listenRequestAuthCode() {
    void onSuccess() {
      setState(() {
        _isRequestAuthCodePressed = true;
      });
      SnackBarHelper.showTextSnackBar(context, "인증번호가 발송되었습니다.");
    }

    ref.listen(
      requestRegisterAuthCodeControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
              onSuccess();
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

  void _listenEmailValidation() {
    void onSuccess() {
      SnackBarHelper.showTextSnackBar(context, "인증번호 확인이 성공했습니다.");
      _countdownTimer.cancel();
      setState(() {
        _isEmailVerified = true;
      });
    }

    ref.listen(
      verifyRegisterAuthCodeControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
            }
            onSuccess();
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

  void _listenRegister() {
    void onSuccess() {
      SnackBarHelper.showTextSnackBar(context, "회원가입이 완료되었습니다.");
      AutoRouter.of(context).popUntilRoot();
      AutoRouter.of(context).replace(LoginRoute());
    }

    ref.listen(
      registerControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
              onSuccess();
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

/// 입력 정보 라벨 위젯
class InputLabel extends StatelessWidget {
  final String label;

  InputLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: AppSize.of(context).safeBlockHorizontal * 0.5,
      ),
      margin:
          EdgeInsets.only(bottom: AppSize.of(context).safeBlockVertical * 1.5),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: AppSize.of(context).safeBlockHorizontal * 4,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

/// 인증번호 받기 버튼
/// 한번 누르면 onPressed 함수가 secondOnPressed로 바뀐다.
class GetAuthenticationButton extends StatefulWidget {
  final void Function() firstOnPressed;
  final void Function() secondOnPressed;
  final bool enabled;

  const GetAuthenticationButton({
    super.key,
    required this.firstOnPressed,
    required this.secondOnPressed,
    this.enabled = true,
  });

  @override
  State<GetAuthenticationButton> createState() =>
      _GetAuthenticationButtonState();
}

class _GetAuthenticationButtonState extends State<GetAuthenticationButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.of(context).safeBlockHorizontal * 27.78,
      child: AppCommonTextButton(
        text: Text(
          '인증번호 받기',
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: widget.enabled
            ? Theme.of(context).colorScheme.primary
            : AppColors.greyLight,
        cornerRadius: 6,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: () {
          if (!widget.enabled) {
            return;
          }
          if (_isPressed) {
            widget.secondOnPressed();
          } else {
            _isPressed = true;
            widget.firstOnPressed();
          }
        },
      ),
    );
  }
}

/// 기수 선택 드롭아웃 위젯
class GenerationDropdown extends StatelessWidget {
  final int? selectedValue;
  final void Function(int?) onChanged;
  final bool doValidate;

  late final Color borderColor;

  GenerationDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
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
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            "본인의 기수를 선택해 주세요.",
            style: GoogleFonts.roboto(
              fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: List.generate(
            AppConstants.maxGeneration,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                "${index + 1}기",
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

  final List<String> profileUrls =
      List.generate(8, (index) => 'assets/profiles/profile_${index + 1}.svg');

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
              width: AppSize.of(context).safeBlockHorizontal * 19,
              height: AppSize.of(context).safeBlockHorizontal * 19,
              padding: EdgeInsets.all(
                  AppSize.of(context).safeBlockHorizontal * 0.667),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedProfileIndex == index
                      ? Color(0xFFB1E2B6)
                      : Color(0xFFE9E9E9),
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
