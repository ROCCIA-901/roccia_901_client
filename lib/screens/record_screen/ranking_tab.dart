import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum RankingType {
  weekly,
  all,
}

class RankingTab extends StatefulWidget {
  const RankingTab({super.key});

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  /// 주간, 전체 중 어느 타입의 랭킹을 보여줄지
  RankingType rakingType = RankingType.weekly;

  /// 주간 랭킹에서 어느 주간을 보여줄지
  late int rankingWeek;

  /// 전체 랭킹에서 어느 기수를 보여줄지
  late int rankingGeneration;

  @override
  void initState() {
    super.initState();
    rankingWeek = 1;
    rankingGeneration = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.maxFinite, height: 25),

        /// 주간, 전체 랭킹 버튼 그룹
        RankingTypeButtonGroup(
          rankingType: rakingType,
          changeRankingType: changeRankingType,
        ),
        SizedBox(width: double.maxFinite, height: 15),

        /// 주차 및 기수 변경 위젯
        RankingTurnGroup(
          rankingType: rakingType,
          rankingWeek: rankingWeek,
          rankingGeneration: rankingGeneration,
        ),

        /// 랭킹 기준 안내 버튼
        RankingCriteriaButton(),

        /// 회색 가로선
        Container(height: 1.5, color: Color(0xFFF1F1F1)),
      ],
    );
  }

  void changeRankingType() {
    setState(() {
      switch (rakingType) {
        case (RankingType.weekly):
          rakingType = RankingType.all;
          break;
        case (RankingType.all):
          rakingType = RankingType.weekly;
          break;
      }
    });
  }
}

/// 주간, 전체 랭킹 버튼 그룹
class RankingTypeButtonGroup extends StatelessWidget {
  final RankingType rankingType;
  final void Function() changeRankingType;

  const RankingTypeButtonGroup({
    super.key,
    required this.rankingType,
    required this.changeRankingType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        /// 주간 랭킹 버튼
        RankingTypeBotton(
          text: '주간',
          active: rankingType == RankingType.weekly ? true : false,
          onPressed: changeRankingType,
        ),
        SizedBox(width: 20),

        /// 전체 랭킹 버튼
        RankingTypeBotton(
          text: '전체',
          active: rankingType == RankingType.all ? true : false,
          onPressed: changeRankingType,
        ),
      ],
    );
  }
}

class RankingTypeBotton extends StatelessWidget {
  final String text;
  final bool active;
  final void Function()? onPressed;

  const RankingTypeBotton({
    super.key,
    required this.text,
    required this.active,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double widthRatio = 5;
    const double heightRatio = 2;
    const double buttonScale = 17;
    return SizedBox(
      width: widthRatio * buttonScale,
      height: heightRatio * buttonScale,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          backgroundColor: Color(0xFFE0E0E0),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Theme.of(context).colorScheme.primary,
          disabledForegroundColor: Colors.white,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: active ? onPressed : null,
        child: Text(text),
      ),
    );
  }
}

/// 주차 및 기수 변경 위젯
class RankingTurnGroup extends StatelessWidget {
  final RankingType rankingType;
  final int rankingWeek;
  final int rankingGeneration;

  const RankingTurnGroup({
    super.key,
    required this.rankingType,
    required this.rankingWeek,
    required this.rankingGeneration,
  });

  @override
  Widget build(BuildContext context) {
    // 현재 표시 중인 랭킹의 주차 또는 기수 정보
    final String nowRanking = switch (rankingType) {
      RankingType.weekly => '$rankingWeek주차',
      RankingType.all => '$rankingGeneration기',
    };
    // arrow icon size
    const double arrowIconSize = 18;

    return SizedBox(
      width: double.maxFinite,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF7B7B7B),
              size: arrowIconSize,
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            width: 240,
            child: Text(
              nowRanking,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7B7B7B),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF7B7B7B),
              size: arrowIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// 랭킹 기준 안내 버튼
class RankingCriteriaButton extends StatelessWidget {
  const RankingCriteriaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      alignment: Alignment.centerRight,
      width: double.maxFinite,
      height: 30,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
        ),
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/question_mark_circle.svg',
          color: Color(0xFFE0E0E0),
          width: 13,
        ),
        label: Text(
          '랭킹 기준',
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// 랭킹 목록
class RankingListView extends StatelessWidget {
  final RankingType rankingType;
  final int rankingWeek;
  final int rankingGeneration;

  const RankingListView({
    super.key,
    required this.rankingType,
    required this.rankingWeek,
    required this.rankingGeneration,
  });

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      controller: controller,
      children: const <Widget>[
        Center(
          child: Text('First Page'),
        ),
        Center(
          child: Text('Second Page'),
        ),
        Center(
          child: Text('Third Page'),
        ),
      ],
    );
  }
}
