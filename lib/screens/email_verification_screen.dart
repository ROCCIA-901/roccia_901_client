import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/size_config.dart';
import '../widgets/app_common_text_button.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

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
                      SizedBox(
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
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: '1:00',
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
