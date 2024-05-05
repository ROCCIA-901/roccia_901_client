import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/presentation/screens/password_reset_screen.dart';
import 'package:untitled/presentation/screens/shared/exception_handler_on_view.dart';
import 'package:untitled/presentation/viewmodels/authentication/password_update_viewmodel.dart';

import '../../constants/app_constants.dart';
import '../../constants/size_config.dart';
import '../../utils/countdown_timer.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/snack_bar_helper.dart';
import '../../widgets/app_common_text_button.dart';

@RoutePage()
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _authCodeFormKey = GlobalKey<FormState>();

  /// 이메일과 인증번호를 저장하는 변수
  late String _email;
  late String _authenticationCode;

  /// 인증 타임아웃 카운트다운을 위한 변수
  late int _currentCount;
  late CountdownTimer _countdownTimer;

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
    _setListeners();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.of(context).safeBlockHorizontal * 7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),

              /// "비밀번호 찾기"
              InputLabel(label: "비밀번호 찾기"),

              /// 이메일 입력 필드 & 인증번호 받기 버튼
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  bottom: AppSize.of(context).safeBlockHorizontal * 2,
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
                                        3.5,
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
                          _requestAuthCode();
                        },
                        secondOnPressed: () {
                          setState(() {
                            _currentCount = AppConstants.authenticationTimeOut;
                          });
                          _countdownTimer.restart();
                          _requestAuthCode();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// 인증번호 입력 필드
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  bottom: AppSize.of(context).safeBlockHorizontal * 3,
                ),
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
                          width: AppSize.of(context).safeBlockHorizontal * 85.7,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      AppSize.of(context).safeBlockHorizontal *
                                          3.5,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: '인증번호 입력',
                                  labelStyle: GoogleFonts.roboto(
                                    fontSize: AppSize.of(context)
                                            .safeBlockHorizontal *
                                        3.5,
                                    color: Color(0xFFD1D3D9),
                                  ),
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
                                        3.7,
                                    color: Color(0xFFD1D3D9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// "이메일 인증으로..." 버튼
              AspectRatio(
                  aspectRatio: 31 / 4,
                  child: AppCommonTextButton(
                    text: Text(
                      '이메일 인증으로 비밀번호 변경하기',
                      style: GoogleFonts.inter(
                        fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    cornerRadius: 10,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    onPressed: () {
                      _verifyAuthCode();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          bottom: AppSize.of(context).safeBlockVertical * 7,
        ),
        height: AppSize.of(context).safeBlockVertical * 40,
        child: Image(
            image: AssetImage('assets/logos/roccia_full_logo.png'),
            height: min(AppSize.of(context).safeBlockHorizontal * 22,
                AppSize.of(context).safeBlockVertical * 16)));
  }

  /// 카운트다운 초당 callback 함수
  void decreaseCount() {
    setState(() {
      if (_currentCount > 0) {
        _currentCount--;
      }
    });
  }

  // ------------------------------------------------------------------------ //
  // Event Handlers                                                           //
  // ------------------------------------------------------------------------ //
  /// 인증번호 받기 버튼을 눌렀을 때 호출되는 함수
  void _requestAuthCode() {
    if (!(_emailFormKey.currentState!.validate())) {
      return;
    }
    _emailFormKey.currentState!.save();
    ref.read(requestPasswordUpdateAuthCodeControllerProvider.notifier).execute(
          email: _email,
        );
  }

  /// 비밀번호 변경하기 버튼 눌렀을 때 호출되는 함수
  void _verifyAuthCode() {
    if (!(_emailFormKey.currentState!.validate()) ||
        !(_authCodeFormKey.currentState!.validate())) {
      return;
    }
    _emailFormKey.currentState!.save();
    _authCodeFormKey.currentState!.save();
    ref.read(verifyPasswordUpdateAuthCodeControllerProvider.notifier).execute(
          email: _email,
          authCode: _authenticationCode,
        );
  }

  // ------------------------------------------------------------------------ //
  // Notification Listeners                                                   //
  // ------------------------------------------------------------------------ //
  void _setListeners() {
    _listenRequestAuthCode();
    _listenVerifyAuthCode();
  }

  void _listenRequestAuthCode() {
    ref.listen(
      requestPasswordUpdateAuthCodeControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
              SnackBarHelper.showTextSnackBar(context, "인증번호가 발송되었습니다.");
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

  void _listenVerifyAuthCode() {
    void onSuccess() {
      SnackBarHelper.showTextSnackBar(context, "인증번호 확인이 성공했습니다.");
      AutoRouter.of(context).pushWidget(PasswordResetScreen(email: _email));
    }

    ref.listen(
      verifyPasswordUpdateAuthCodeControllerProvider,
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
      margin: EdgeInsets.only(
          bottom: AppSize.of(context).safeBlockHorizontal * 1.5),
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
  const GetAuthenticationButton({
    super.key,
    required this.firstOnPressed,
    required this.secondOnPressed,
  });

  final void Function() firstOnPressed;
  final void Function() secondOnPressed;

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: 6,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: () {
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
