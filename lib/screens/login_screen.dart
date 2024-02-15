import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/utils/size_config.dart';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical * 20),
              // Placeholder for logo
              SvgPicture.asset(
                'assets/roccia_full_logo.svg',
                width: SizeConfig.safeBlockHorizontal * 45,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 8),
              // Email Field
              TextFormField(
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
              SizedBox(height: SizeConfig.safeBlockHorizontal * 2),
              // Password Field
              TextFormField(
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
              SizedBox(height: SizeConfig.safeBlockHorizontal * 3),
              // Login Button
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: SvgPicture.asset(
                    'assets/icons/login_button.svg',
                    width: SizeConfig.safeBlockHorizontal * 93,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
