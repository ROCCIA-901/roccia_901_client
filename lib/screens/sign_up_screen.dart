import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

import '../utils/size_config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/sign_up.svg',
            color: Color(0xFF000000),
            width: SizeConfig.safeBlockHorizontal * 25.28,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 7,
            vertical: SizeConfig.safeBlockVertical * 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 이메일
              InputLabel(label: '이메일'),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 1, top: 0),
                    child: SizedBox(
                      width: 195,
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '이메일을 입력해주세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, top: 0),
                    child: InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/buttons/auth_num_get.svg',
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: ' 1:00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/buttons/auth_num_submit.svg',
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
              // 새로운 비밀번호 입력 필드 추가
              SizedBox(height: 50), // 필드 사이 간격 추가
              Text(
                ' 비밀번호                                                                   ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 입력해주세요.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 추가 필드를 여기에 배치할 수 있습니다.
              SizedBox(height: 50),
              Text(
                '비밀번호 확인                                                                   ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 다시 한번 입력해주세요.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                '이름                                                                   ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '본인 이름을 입력해주세요.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 다시 한번 입력해주세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 다시 한번 입력해주세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 다시 한번 입력해주세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .text, // 비밀번호 입력이므로 TextInputType.text 사용
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: '비밀번호를 다시 한번 입력해주세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputLabel extends StatelessWidget {
  final String label;

  const InputLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.safeBlockHorizontal * 0.5,
      ),
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
