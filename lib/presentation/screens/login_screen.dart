import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/presentation/screens/shared/exception_handler_on_view.dart';

import '../../constants/app_colors.dart';
import '../../constants/size_config.dart';
import '../../utils/app_loading_overlay.dart';
import '../../utils/app_router.dart';
import '../../utils/snack_bar_helper.dart';
import '../../widgets/app_common_text_button.dart';
import '../viewmodels/authentication/login_viewmodel.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  final void Function(BuildContext)? onInit;
  final void Function(BuildContext, bool)? onResult;

  LoginScreen({
    super.key,
    this.onInit,
    this.onResult,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit!(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    AppLoadingOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setListener();
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

              /// Email Field
              EmailField(controller: _emailController),
              SizedBox(height: AppSize.of(context).safeBlockHorizontal * 2),

              /// Password Field
              PasswordField(
                controller: _passwordController,
                onInputAction: () {
                  _onPressedLogInButton(context, ref);
                },
              ),
              SizedBox(height: AppSize.of(context).safeBlockHorizontal * 3),

              /// Login Button
              LoginButton(
                onPressed: () {
                  _onPressedLogInButton(context, ref);
                },
              ),
              SizedBox(height: AppSize.of(context).safeBlockHorizontal * 2.5),
              _buildSignInAndPasswordResetButton(),
              SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------ //
  // Sub Widgets                                                              //
  // ------------------------------------------------------------------------ //
  Widget _buildLogo() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          bottom: AppSize.of(context).safeBlockVertical * 7,
        ),
        height: AppSize.of(context).safeBlockVertical * 40,
        child: Image(
            image: AssetImage('assets/logos/roccia_full_logo.png'),
            height: min(AppSize.of(context).safeBlockHorizontal * 22, AppSize.of(context).safeBlockVertical * 16)));
  }

  Widget _buildSignInAndPasswordResetButton() {
    Widget textButton(String text, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        splashColor: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            bottom: AppSize.of(context).safeBlockHorizontal * 1,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
              color: AppColors.greyMediumDark,
            ),
          ),
        ),
      );
    }

    Widget separator = Container(
      width: AppSize.of(context).safeBlockHorizontal * 2.5,
      alignment: Alignment.center,
      child: Text(
        '|',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
          color: AppColors.greyMedium,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        textButton(
          '회원가입',
          () {
            AutoRouter.of(context).push(SignUpRoute());
          },
        ),
        separator,
        textButton(
          '비밀번호 찾기',
          () {
            AutoRouter.of(context).push(EmailVerificationRoute());
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------------------ //
  // Event Handlers                                                           //
  // ------------------------------------------------------------------------ //
  Future<void> _onPressedLogInButton(BuildContext context, WidgetRef ref) async {
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

  // ------------------------------------------------------------------------ //
  // Notification Listeners                                                   //
  // ------------------------------------------------------------------------ //
  void _setListener() {
    _listenLogin();
  }

  void _listenLogin() {
    void onSuccess() {
      if (widget.onResult != null) {
        widget.onResult!(context, true);
      } else {
        AutoRouter.of(context).replace(HomeRoute());
      }
    }

    ref.listen(loginControllerProvider, (previous, next) {
      next.when(
        data: (value) {
          if (previous is AsyncLoading) {
            AppLoadingOverlay.hide();
            onSuccess();
          }
        },
        loading: () {
          AppLoadingOverlay.show(context);
        },
        error: (error, stackTrace) {
          if (previous is AsyncLoading) {
            AppLoadingOverlay.hide();
          }
          if (error is Exception) {
            exceptionHandlerOnView(context, e: error, stackTrace: stackTrace);
          }
        },
      );
    });
  }
}

/// Email Field
class EmailField extends StatelessWidget {
  final TextEditingController controller;

  EmailField({
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
        style: GoogleFonts.inter(
          fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
          color: Colors.black,
        ),
        maxLines: 1,
        decoration: InputDecoration(
          hintText: '이메일',
          hintStyle: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            color: Color(0xFFD1D3D9),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.only(
            left: AppSize.of(context).safeBlockHorizontal * 3,
            bottom: AppSize.of(context).safeBlockHorizontal * 1.5,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSize.of(context).safeBlockHorizontal * 2,
            ),
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
  final VoidCallback onInputAction;

  PasswordField({
    super.key,
    required this.controller,
    required this.onInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 31 / 4,
      child: TextFormField(
        obscureText: true,
        controller: controller,
        style: GoogleFonts.inter(
          fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
          color: Colors.black,
        ),
        maxLines: 1,
        decoration: InputDecoration(
          hintText: '비밀번호',
          hintStyle: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
            color: Color(0xFFD1D3D9),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.only(
            left: AppSize.of(context).safeBlockHorizontal * 3,
            bottom: AppSize.of(context).safeBlockHorizontal * 1.5,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppSize.of(context).safeBlockHorizontal * 2,
            ),
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
            fontSize: AppSize.of(context).safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
