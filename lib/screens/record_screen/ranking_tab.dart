import 'package:flutter/material.dart';
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
  RankingType rakingType = RankingType.weekly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.maxFinite, height: 30),
        RankingTypeButtonGroup(
          rankingType: rakingType,
          changeRankingType: changeRankingType,
        ),
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
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xFFE0E0E0),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Theme.of(context).colorScheme.primary,
        disabledForegroundColor: Colors.white,
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: active ? onPressed : null,
      child: Text(text),
    );
  }
}
