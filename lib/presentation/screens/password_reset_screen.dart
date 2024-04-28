import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/presentation/viewmodels/shared/notification_exception.dart';
import 'package:untitled/utils/snack_bar_helper.dart';

import '../../constants/size_config.dart';
import '../../utils/dialog_helper.dart';
import '../../widgets/app_common_text_button.dart';
import '../viewmodels/authentication/password_update_viewmodel.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  final String email;

  const PasswordResetScreen({super.key, required this.email});

  @override
  ConsumerState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _password;
  late String _passwordConfirm;

  @override
  Widget build(BuildContext context) {
    _receiveNotification(context, ref);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 7,
          ),
          child: Form(
            key: _formKey,
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
                SizedBox(height: SizeConfig.safeBlockVertical * 6),

                /// "새 비밀번호"
                InputLabel(label: "새 비밀번호"),
                // 새 비밀번호 입력 필드
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
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: '영문, 숫자, 특수문자를 포함하여 7자 이상 입력해 주세요.',
                        labelStyle: GoogleFonts.roboto(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.2,
                          color: Color(0xFFD1D3D9),
                        ),
                        errorStyle: TextStyle(
                          height: 0.01,
                          color: Colors.transparent,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          SnackBarHelper.showTextSnackBar(
                            context,
                            '비밀번호를 입력해 주세요.',
                          );
                          return '';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value ?? '';
                      },
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
                    child: TextFormField(
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
                        errorStyle: TextStyle(
                          height: 0.01,
                          color: Colors.transparent,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordConfirm = value ?? '';
                      },
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
                      onPressed: () {
                        _updatePassword(ref);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updatePassword(WidgetRef ref) {
    if (!(_formKey.currentState!.validate())) {
      return;
    }
    _formKey.currentState!.save();
    ref.read(updatePasswordControllerProvider.notifier).execute(
          email: widget.email,
          password: _password,
          passwordConfirm: _passwordConfirm,
        );
    // 비밀번호 변경 성공 시
    // Navigator.of(context).pushNamed('/login');
  }

  void _receiveNotification(BuildContext context, WidgetRef ref) {
    _checkUpdatePassword(context, ref);
  }

  void _checkUpdatePassword(BuildContext context, WidgetRef ref) {
    ref.listen(
      updatePasswordControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
              SnackBarHelper.showTextSnackBar(context, "비밀번호가 변경되었습니다.");
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
      },
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
