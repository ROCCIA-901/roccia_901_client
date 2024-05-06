import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/constants/app_colors.dart';

import '../../../constants/size_config.dart';

class MyPageHeader extends StatefulWidget {
  final String profileImagePath;
  final String introduction;

  const MyPageHeader({
    super.key,
    required this.profileImagePath,
    required this.introduction,
  });

  @override
  State<MyPageHeader> createState() => _MyPageHeaderState();
}

class _MyPageHeaderState extends State<MyPageHeader> {
  final GlobalKey _introductionBoxKey = GlobalKey();

  double _introductionBoxHeight = 0;

  @override
  void initState() {
    super.initState();
    _setIntroductionBoxHeight();
  }

  void _setIntroductionBoxHeight() {
    void callback() {
      final RenderBox introductionBoxRenderBox =
          _introductionBoxKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _introductionBoxHeight = introductionBoxRenderBox.size.height;
      });
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    _setIntroductionBoxHeight();
    return Column(
      children: [
        _ProfileImage(profileImagePath: widget.profileImagePath),
        Stack(
          children: [
            _Background(height: _introductionBoxHeight),
            _IntroductionBox(
              key: _introductionBoxKey,
              introduction: widget.introduction,
            ),
          ],
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  final double _height;

  const _Background({
    super.key,
    required double height,
  }) : _height = height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: AppColors.primaryLight,
            ),
          ),
          Container(
            width: double.infinity,
            height: AppSize.of(context).safeBlockHorizontal * 0.5,
            color: AppColors.greyMediumDark,
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String profileImagePath;

  const _ProfileImage({
    super.key,
    required this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: AppSize.of(context).safeBlockHorizontal * 1,
        bottom: AppSize.of(context).safeBlockHorizontal * 1,
      ),
      alignment: Alignment.center,
      color: AppColors.primaryLight,
      child: SvgPicture.asset(
        profileImagePath,
        width: AppSize.of(context).safeBlockHorizontal * 20,
        height: AppSize.of(context).safeBlockHorizontal * 20,
      ),
    );
  }
}

class _IntroductionBox extends StatelessWidget {
  final String _introduction;

  const _IntroductionBox({
    super.key,
    required String introduction,
  }) : _introduction = introduction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.of(context).safeBlockHorizontal * 84,
      constraints: BoxConstraints(
        minHeight: AppSize.of(context).safeBlockHorizontal * 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 3),
        border: Border.all(
          width: AppSize.of(context).safeBlockHorizontal * 0.5,
          color: AppColors.greyMedium,
        ),
      ),
      margin: EdgeInsets.only(
        top: AppSize.of(context).safeBlockHorizontal * 2,
        bottom: AppSize.of(context).safeBlockHorizontal * 2,
        left: AppSize.of(context).safeBlockHorizontal * 8,
        right: AppSize.of(context).safeBlockHorizontal * 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 2,
        vertical: AppSize.of(context).safeBlockHorizontal * 2,
      ),
      alignment: Alignment.center,
      child: Text(
        _introduction,
        softWrap: true,
        style: TextStyle(
          fontSize: AppSize.of(context).font.headline3,
          height: 1.5,
        ),
      ),
    );
  }
}
