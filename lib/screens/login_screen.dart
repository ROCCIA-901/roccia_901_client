import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/config/size_config.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              EmailField(),
              SizedBox(height: SizeConfig.safeBlockHorizontal * 2),

              /// Password Field
              PasswordField(),
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
                    onPressed: () {},
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Email Field
class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 31 / 4,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
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
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 31 / 4,
      child: TextFormField(
        obscureText: true,
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
