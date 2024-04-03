import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/config/size_config.dart';
import 'package:untitled/services/api_client.dart';
import 'package:untitled/services/user_authentication/login_service.dart';
import 'package:untitled/utils/app_storage.dart';
import 'package:untitled/utils/snack_bar_helper.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

import '../utils/dialog_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              SizedBox(height: SizeConfig.safeBlockVertical * 8),

              /// Email Field
              EmailField(controller: _emailController),
              SizedBox(height: SizeConfig.safeBlockHorizontal * 2),

              /// Password Field
              PasswordField(controller: _passwordController),
              SizedBox(height: SizeConfig.safeBlockHorizontal * 3),

              /// Login Button
              AspectRatio(
                  aspectRatio: 31 / 4,
                  child: AppCommonTextButton(
                    text: Text(
                      '로그인',
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
                      _onPressedLoginButton(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedLoginButton(BuildContext context) async {
    // 유효성 검사
    if (!EmailValidator.validate(_emailController.text)) {
      SnackBarHelper.showTextSnackBar(context, '이메일 형식이 아닙니다.');
      return;
    } else if (_passwordController.text.isEmpty) {
      SnackBarHelper.showTextSnackBar(context, '비밀번호를 입력해 주세요.');
      return;
    }

    // 로딩 스피너
    DialogHelper.showLoaderDialog(context);
    if (!context.mounted) return;

    // 로그인 요청
    try {
      final data = await LoginService()
          .authenticateUser(_emailController.text, _passwordController.text);
    } on ApiException catch (e) {
      debugPrint(e.toString());
      if (e.statusCode == null) {
        if (context.mounted) SnackBarHelper.showApiErrorSnackBar(context);
      } else {
        if (context.mounted) SnackBarHelper.showTextSnackBar(context, e.detail);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) SnackBarHelper.showApiErrorSnackBar(context);
    } finally {
      // 로딩 스피너 닫기
      if (context.mounted) Navigator.pop(context);
    }
  }
}

/// Email Field
class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 31 / 4,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          hintText: '이메일',
          hintStyle: GoogleFonts.archivoBlack(
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            color: Color(0xFFD1D3D9),
          ),
          filled: true,
          fillColor: Colors.white,
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
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

// Password Field
class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 31 / 4,
      child: TextFormField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
          hintText: '비밀번호',
          hintStyle: GoogleFonts.archivoBlack(
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            color: Color(0xFFD1D3D9),
          ),
          filled: true,
          fillColor: Colors.white,
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
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
