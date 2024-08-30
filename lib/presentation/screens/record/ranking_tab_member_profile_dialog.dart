import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled/constants/app_enum.dart';
import 'package:untitled/presentation/viewmodels/user/member_profile_viewmodel.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/size_config.dart';
import '../shared/exception_handler_on_view.dart';

class RankingTabMemberProfileDialog extends ConsumerWidget {
  final int _userId;

  const RankingTabMemberProfileDialog({
    super.key,
    required int userId,
  }) : _userId = userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var memberProfileStateAsync = ref.watch(memberProfileViewmodelProvider(_userId));

    if (memberProfileStateAsync is! AsyncData || memberProfileStateAsync.value == null) {
      if (memberProfileStateAsync is AsyncError) {
        exceptionHandlerOnView(
          context,
          e: memberProfileStateAsync.error as Exception,
          stackTrace: memberProfileStateAsync.stackTrace ?? StackTrace.current,
        );
      }
      return Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppColors.primary,
          size: AppSize.of(context).safeBlockHorizontal * 10,
        ),
      );
    }
    var memberProfileState = memberProfileStateAsync.value!;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 10,
      ),
      child: Container(
        width: double.infinity,
        height: AppSize.of(context).safeBlockVertical * 70,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppSize.of(context).safeBlockHorizontal * 5,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 17,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildProfileDetailWidgets(context, memberProfileState),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: _CloseButton(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileDetailWidgets(BuildContext context, MemberProfileStateModel profile) {
    final double separatorHeight = AppSize.of(context).safeBlockHorizontal * 3;
    return [
      _Header(
        profileImagePath: "assets/profiles/profile_${profile.profileImageNumber}.svg",
        introduction: profile.introduction,
      ),
      SizedBox(height: separatorHeight),
      Row(
        children: [
          _LabelText(text: '이름'),
          _ContentText(text: profile.name),
        ],
      ),
      SizedBox(height: separatorHeight),
      Row(
        children: [
          _LabelText(text: '지점'),
          _ContentText(text: Location.toName[profile.location]!),
        ],
      ),
      SizedBox(height: separatorHeight),
      Row(
        children: [
          _LabelText(text: '기수'),
          _ContentText(text: profile.generation),
        ],
      ),
      SizedBox(height: separatorHeight),
      Row(
        children: [
          _LabelText(text: '난이도'),
          _ContentText(text: BoulderLevel.toName[profile.level]!),
        ],
      ),
      SizedBox(height: separatorHeight),
    ];
  }
}

class _LabelText extends StatelessWidget {
  final String text;

  _LabelText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.only(
          left: AppSize.of(context).safeBlockHorizontal * 8,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppSize.of(context).font.headline2,
            color: AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}

class _ContentText extends StatelessWidget {
  final String text;

  _ContentText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSize.of(context).font.headline2,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        '닫기',
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: AppSize.of(context).font.headline1,
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  final String profileImagePath;
  final String introduction;

  const _Header({
    super.key,
    required this.profileImagePath,
    required this.introduction,
  });

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final GlobalKey _introductionBoxKey = GlobalKey();

  double _introductionBoxHeight = 0;

  @override
  void initState() {
    super.initState();
    _setIntroductionBoxHeight();
  }

  void _setIntroductionBoxHeight() {
    void callback() {
      final RenderBox introductionBoxRenderBox = _introductionBoxKey.currentContext!.findRenderObject() as RenderBox;
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
        top: AppSize.of(context).safeBlockHorizontal * 4,
        bottom: AppSize.of(context).safeBlockHorizontal * 1,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.of(context).safeBlockHorizontal * 5),
          topRight: Radius.circular(AppSize.of(context).safeBlockHorizontal * 5),
        ),
      ),
      child: SvgPicture.asset(
        profileImagePath,
        width: AppSize.of(context).safeBlockHorizontal * 15,
        height: AppSize.of(context).safeBlockHorizontal * 15,
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
        borderRadius: BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 3),
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
          fontSize: AppSize.of(context).font.content,
          height: 1.5,
        ),
      ),
    );
  }
}
