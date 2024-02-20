import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/config/app_constants.dart';

import '../config/size_config.dart';
import '../utils/countdown_timer.dart';
import '../widgets/app_common_text_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical * 18),

              /// Placeholder for logo
              SvgPicture.asset(
                'assets/roccia_full_logo.svg',
                width: SizeConfig.safeBlockHorizontal * 50,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 6),

              /// "비밀번호 찾기"
              InputLabel(label: "비밀번호 찾기"),

              /// 이메일 입력 필드 & 인증번호 받기 버튼
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockVertical * 0.7,
                ),
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// 이메일 입력 필드
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 55.56,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: '이메일을 입력해주세요.',
                            labelStyle: GoogleFonts.roboto(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              color: Color(0xFFD1D3D9),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 3,
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
                        ),
                      ),

                      /// 인증번호 받기 버튼
                      GetAuthenticationButton(
                        firstOnPressed: _countdownTimer.start,
                        secondOnPressed: () {
                          setState(() {
                            _currentCount = AppConstants.authenticationTimeOut;
                          });
                          _countdownTimer.restart();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// 인증번호 입력 필드 & 인증번호 확인 버튼
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockVertical * 2.0,
                ),
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// 인증번호 입력 필드
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 55.56,
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            TextField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: GoogleFonts.roboto(
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.safeBlockHorizontal * 3,
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
                            ),
                            // 카운트 다운 타이머
                            Positioned(
                              top: SizeConfig.safeBlockHorizontal * 3.2,
                              right: SizeConfig.safeBlockHorizontal * 3.2,
                              child: Text(
                                "${(_currentCount / 60).floor()}:${(_currentCount % 60).toString().padLeft(2, '0')}",
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3.7,
                                  color: Color(0xFFD1D3D9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 인증번호 확인 버튼
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 27.78,
                        child: AppCommonTextButton(
                          text: Text(
                            '인증번호 확인',
                            style: GoogleFonts.inter(
                              fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          cornerRadius: 10,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          onPressed: () {},
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
                        fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    cornerRadius: 10,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    onPressed: () {},
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// 카운트다운 초당 callback 함수
  void decreaseCount() {
    setState(() {
      if (_currentCount > 0) {
        _currentCount--;
      }
    });
  }
}

/// 입력 정보 라벨 위젯
class InputLabel extends StatelessWidget {
  final String label;

  const InputLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: SizeConfig.safeBlockHorizontal * 0.5,
      ),
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1.5),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
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
      width: SizeConfig.safeBlockHorizontal * 27.78,
      child: AppCommonTextButton(
        text: Text(
          '인증번호 받기',
          style: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: 10,
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
