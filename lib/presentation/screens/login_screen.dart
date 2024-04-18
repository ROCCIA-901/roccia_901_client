import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/size_config.dart';
import '../../exceptions/notification_exception.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/snack_bar_helper.dart';
import '../../widgets/app_common_text_button.dart';
import '../viewmodels/authentication/login_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    _receiveNotification();
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
                'assets/logos/roccia_full_logo.svg',
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
              LoginButton(
                onPressed: () {
                  _onPressed(context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    // 유효성 검사
    if (!EmailValidator.validate(email)) {
      SnackBarHelper.showTextSnackBar(context, '이메일 형식이 아닙니다.');
      return;
    } else if (password.isEmpty) {
      SnackBarHelper.showTextSnackBar(context, '비밀번호를 입력해 주세요.');
      return;
    }

    // 로그인 요청
    await ref.read(loginControllerProvider.notifier).execute(
          email: email,
          password: password,
        );
  }

  void _receiveNotification() {
    _checkLogin();
  }

  void _checkLogin() {
    ref.listen(loginControllerProvider, (previous, next) {
      next.when(
        data: (value) {
          if (previous is AsyncLoading) {
            Navigator.pop(context);
            SnackBarHelper.showTextSnackBar(context, "+_+: 로그인 성공.");
          }
        },
        loading: () {
          DialogHelper.showLoaderDialog(context);
        },
        error: (error, stackTrace) {
          if (previous is AsyncLoading) {
            Navigator.pop(context);
          }
          if (error is NotificationException) {
            SnackBarHelper.showTextSnackBar(context, error.message);
          } else {
            SnackBarHelper.showErrorSnackBar(context);
          }
        },
      );
    });
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

/// Password Field
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

/// Login Button
class LoginButton extends StatelessWidget {
  LoginButton({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
          onPressed();
        },
      ),
    );
  }
}
