import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/config/app_constants.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

import '../config/size_config.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// 텍스트 필드 controllers
  // 이메일
  final TextEditingController _emailController = TextEditingController();
  // 인증번호
  final TextEditingController _authenticationController =
      TextEditingController();
  // 비밀번호
  final TextEditingController _passwordController = TextEditingController();
  // 비밀번호 확인
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  // 이름
  final TextEditingController _nameController = TextEditingController();
  // 소개
  final TextEditingController _introductionController = TextEditingController();

  /// Dropdown Button2에서 선택된 값들(package 이름이 button2 입니다.)
  /// 선택되지 않은 초기값은 null
  // 기수
  int? _generation;
  // 역할
  UserRole? _userRole;
  // 운동 지점
  Location? _location;
  // 운동 난이도
  Level? _level;

  /// 선택된 프로필
  int? _profileIndex;

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
            vertical: SizeConfig.safeBlockVertical * 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 이메일 label
              InputLabel(label: '이메일'),
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
                          controller: _emailController,
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
              Container(
                width: double.maxFinite,
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
                          controller: _authenticationController,
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
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 비밀번호 label
              InputLabel(label: '비밀번호'),
              // 비밀번호 입력 필드
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
                    controller: _passwordController,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 비밀번호 확인 label
              InputLabel(label: '비밀번호 확인'),
              // 비밀번호 확인 입력 필드
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
                      labelText: '비밀번호를 다시 한번 입력해주세요.',
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
                    controller: _passwordConfirmController,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 이름 label
              InputLabel(label: '이름'),
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 31 / 4,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: '본인 이름을 입력해 주세요.',
                      labelStyle: GoogleFonts.roboto(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        color: Color(0xFFD1D3D9),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 3,
                        vertical: SizeConfig.safeBlockHorizontal * 2.0,
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
                    controller: _nameController,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 기수 label
              InputLabel(label: '기수'),
              GenerationDropdown(
                selectedValue: _generation,
                onChanged: changeGeneration,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 역할 label
              InputLabel(label: '역할'),
              GenericDropdown(
                values: UserRole.values,
                toName: UserRole.toName,
                selectedValue: _userRole,
                onChanged: changeRole,
                hintText: "본인의 역할을 선택해 주세요.",
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 운동 지점 label
              InputLabel(label: '운동 지점'),
              GenericDropdown(
                values: Location.values,
                toName: Location.toName,
                selectedValue: _location,
                onChanged: changeLocation,
                hintText: "본인의 운동 지점을 선택해 주세요.",
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 운동 난이도 label
              InputLabel(label: '운동 난이도'),
              GenericDropdown(
                values: Level.values,
                toName: Level.toName,
                selectedValue: _level,
                onChanged: changeLevel,
                hintText: "본인의 볼더링 난이도를 선택해 주세요.(더클라임 기준)",
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 프로필 label
              InputLabel(label: '프로필'),
              ProfileSelection(
                selectedProfileIndex: _profileIndex,
                onTap: changeProfileIndex,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),

              /// 소개 label
              InputLabel(label: '소개'),
              // 소개 입력 필드
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLength: 300,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: '본인 소개 글을 작성해 주세요.(300자 이하)',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      color: Color(0xFFD1D3D9),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 3,
                      vertical: SizeConfig.safeBlockHorizontal * 2.0,
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
                  controller: _introductionController,
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 4.7),
            ],
          ),
        ),
      ),
    );
  }

  /// Dropdown Button2 위젯들에서 사용할 callback 함수들
  void changeGeneration(int? generation) {
    setState(() {
      _generation = generation;
    });
  }

  void changeRole(UserRole? userRole) {
    setState(() {
      _userRole = userRole;
    });
  }

  void changeLocation(Location? location) {
    setState(() {
      _location = location;
    });
  }

  void changeLevel(Level? level) {
    setState(() {
      _level = level;
    });
  }

  /// 프로필 선택 callback
  void changeProfileIndex(int index) {
    setState(() {
      _profileIndex = index;
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

/// 기수 선택 드롭아웃 위젯
class GenerationDropdown extends StatelessWidget {
  final int? selectedValue;
  final void Function(int?) onChanged;
  const GenerationDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            "본인의 기수를 선택해 주세요.",
            style: GoogleFonts.roboto(
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: List.generate(
            AppConstants.maxGeneration,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                "${index + 1}기",
                style: GoogleFonts.roboto(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                  color: Color(0xFF4E5055),
                ),
              ),
            ),
          ),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            width: double.maxFinite,
            height: SizeConfig.safeBlockHorizontal * 11.01,
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: SizeConfig.safeBlockHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFD1D3D9),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: SizeConfig.safeBlockHorizontal * 7,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: SizeConfig.safeBlockVertical * 25,
            width: SizeConfig.safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: SizeConfig.safeBlockHorizontal * 11.01,
            padding: EdgeInsets.only(
              left: SizeConfig.safeBlockHorizontal * 3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Generic 드롭다운 위젯
class GenericDropdown<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Map<T, String> toName;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String hintText;

  GenericDropdown({
    super.key,
    required this.values,
    required this.toName,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            hintText,
            style: GoogleFonts.roboto(
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: values.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                toName[value] ?? "error42",
                style: GoogleFonts.roboto(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.0,
                  color: Color(0xFF4E5055),
                ),
              ),
            );
          }).toList(),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            width: double.maxFinite,
            height: SizeConfig.safeBlockHorizontal * 11.01,
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: SizeConfig.safeBlockHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFD1D3D9),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: SizeConfig.safeBlockHorizontal * 7,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: SizeConfig.safeBlockVertical * 25,
            width: SizeConfig.safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: SizeConfig.safeBlockHorizontal * 11.01,
            padding: EdgeInsets.only(
              left: SizeConfig.safeBlockHorizontal * 3,
            ),
          ),
        ),
      ),
    );
  }
}

/// 프로필 선택 위젯
class ProfileSelection extends StatelessWidget {
  final int? selectedProfileIndex; // 처음엔 아무 프로필도 선택되어 있지 않는다.
  final void Function(int) onTap;

  ProfileSelection({
    super.key,
    required this.selectedProfileIndex,
    required this.onTap,
  });

  final List<String> profileUrls =
      List.generate(8, (index) => 'assets/profiles/profile_${index + 1}.svg');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: SizeConfig.safeBlockHorizontal * 2.2,
        children: List.generate(
          profileUrls.length,
          (index) => InkResponse(
            onTap: () {
              onTap(index);
            },
            splashFactory: NoSplash.splashFactory,
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 19,
              height: SizeConfig.safeBlockHorizontal * 19,
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 0.667),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedProfileIndex == index
                      ? Color(0xFFB1E2B6)
                      : Color(0xFFE9E9E9),
                  width: SizeConfig.safeBlockHorizontal * 1,
                ),
              ),
              child: SvgPicture.asset(
                'assets/profiles/profile_${index + 1}.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
