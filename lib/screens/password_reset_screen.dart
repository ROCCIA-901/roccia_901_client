import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/size_config.dart';
import '../widgets/app_common_text_button.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

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

              /// "새 비밀번호"
              InputLabel(label: "새 비밀번호"),
              // 새 비밀번호 입력 필드
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: TextField(
                    // 비밀번호 입력이므로 TextInputType.text 사용
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    // 비밀번호 입력을 위한 설정들
                    obscureText: true, // 비밀번호 숨김 처리
                    enableSuggestions: false, // 제안 비활성화
                    autocorrect: false, // 자동 검사 비활성화
                    decoration: InputDecoration(
                      labelText: '영문, 숫자, 특수문자를 포함하여 7자 이상 입력해 주세요.',
                      labelStyle: GoogleFonts.roboto(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.2,
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
              ),
              SizedBox(
                width: double.maxFinite,
                height: SizeConfig.safeBlockVertical * 2.5,
              ),

              /// "새 비밀번호 확인"
              InputLabel(label: "새 비밀번호 확인"),
              // 새 비밀번호 확인 입력 필드
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: TextField(
                    // 비밀번호 입력이므로 TextInputType.text 사용
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    // 비밀번호 입력을 위한 설정들
                    obscureText: true, // 비밀번호 숨김 처리
                    enableSuggestions: false, // 제안 비활성화
                    autocorrect: false, // 자동 검사 비활성화
                    decoration: InputDecoration(
                      labelText: '비밀번호를 다시 한번 입력해 주세요.',
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
              ),
              SizedBox(
                width: double.maxFinite,
                height: SizeConfig.safeBlockVertical * 2,
              ),

              /// 비밀번호 변경 버튼
              AspectRatio(
                  aspectRatio: 31 / 4,
                  child: AppCommonTextButton(
                    text: Text(
                      '비밀번호 변경하기',
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
