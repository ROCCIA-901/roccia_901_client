// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:untitled/constants/size_config.dart';
//
// enum RankingType {
//   weekly,
//   all,
// }
//
// class RankingTab extends StatefulWidget {
//   const RankingTab({super.key});
//
//   @override
//   State<RankingTab> createState() => _RankingTabState();
// }
//
// class _RankingTabState extends State<RankingTab> {
//   /// 주간, 전체 중 어느 타입의 랭킹을 보여줄지
//   RankingType rankingType = RankingType.weekly;
//
//   // 주간, 기수 시작 값
//   // ex) week = page + weekPageOffset
//   final int weekPageOffset = 1;
//   final int generationPageOffset = 1;
//
//   // 주간 랭킹에서 어느 주간 페이지를 처음 보여줄지
//   late int selectedWeek;
//   // 전체 랭킹에서 어느 주간 페이지를 처음 보여줄지
//   late int selectedGeneration;
//
//   // 주간, 전체 랭킹 page controller
//   late PageController weeklyRankingPageController;
//   late PageController allRankingPageController;
//
//   // 서버로부터 주간, 전체 랭킹 데이터를 받아와 저장하는 변수
//   late final Future<WeeklyRankingsListDTO> futureWeeklyRankingsList;
//   late final Future<OverallRankingsListDTO> futureOverallRankingsList;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedWeek = 1;
//     selectedGeneration = 11;
//     weeklyRankingPageController = PageController(
//       initialPage: selectedWeek - weekPageOffset,
//     );
//     allRankingPageController = PageController(
//       initialPage: selectedGeneration - generationPageOffset,
//     );
//     _asyncInit();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(width: double.maxFinite, height: 25),
//
//         /// 주간, 전체 랭킹 버튼 그룹
//         RankingTypeButtonGroup(
//           rankingType: rankingType,
//           changeRankingType: changeRankingType,
//         ),
//         SizedBox(width: double.maxFinite, height: 15),
//
//         /// 주차 및 기수 변경 위젯
//         RankingTurnGroup(
//           rankingType: rankingType,
//           rankingWeek: selectedWeek,
//           rankingGeneration: selectedGeneration,
//           weeklyRankingPagecontroller: weeklyRankingPageController,
//           allRankingPagecontroller: allRankingPageController,
//         ),
//
//         /// 랭킹 기준 안내 버튼
//         RankingCriteriaButton(),
//
//         /// 회색 가로선
//         Container(height: 1.5, color: Color(0xFFF1F1F1)),
//
//         /// 랭킹 요소 구분
//         RankingCategoryIndicator(),
//
//         /// 랭킹 목록 페이지 뷰
//         switch (rankingType) {
//           RankingType.weekly => WeeklyRankingPageView(
//               weekOffset: weekPageOffset,
//               selectedWeek: selectedWeek,
//               changeWeek: changeRankingWeek,
//               pageController: weeklyRankingPageController,
//               futureWeeklyRankingsList: futureWeeklyRankingsList,
//             ),
//           RankingType.all => AllRankingPageView(
//               generationOffset: generationPageOffset,
//               selectedGeneration: selectedGeneration,
//               changeGeneration: changeRankingGeneration,
//               pageController: allRankingPageController,
//               futureOverallRankingsList: futureOverallRankingsList,
//             ),
//           // RankingType.all => AllRankingPageView(
//           //     generation: 10,
//           //     changeGeneration: changeRankingGeneration,
//           //     pageController: allRankingPageController,
//           //   )
//         }
//       ],
//     );
//   }
//
//   Future<void> _asyncInit() async {
//     futureWeeklyRankingsList = WeeklyRankingService().fetch(year: 2023);
//     futureOverallRankingsList = OverallRankingService().fetch();
//     final weeklyRankingsList = await futureWeeklyRankingsList;
//     debugPrint(weeklyRankingsList.detail);
//     final overallRankingsList = await futureOverallRankingsList;
//     debugPrint(overallRankingsList.detail);
//   }
//
//   /// 랭킹 타입 변환 callback
//   void changeRankingType() {
//     setState(() {
//       switch (rankingType) {
//         case (RankingType.weekly):
//           rankingType = RankingType.all;
//           break;
//         case (RankingType.all):
//           rankingType = RankingType.weekly;
//           break;
//       }
//     });
//   }
//
//   /// 주차 변환 callback
//   void changeRankingWeek(int page) {
//     setState(() {
//       selectedWeek = page + weekPageOffset;
//     });
//   }
//
//   /// 기수 변환 callback
//   void changeRankingGeneration(int page) {
//     setState(() {
//       selectedGeneration = page + generationPageOffset;
//     });
//   }
// }
//
// /// 주간, 전체 랭킹 버튼 그룹
// class RankingTypeButtonGroup extends StatelessWidget {
//   final RankingType rankingType;
//   final void Function() changeRankingType;
//
//   const RankingTypeButtonGroup({
//     super.key,
//     required this.rankingType,
//     required this.changeRankingType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         /// 주간 랭킹 버튼
//         RankingTypeBotton(
//           text: '주간',
//           active: rankingType == RankingType.weekly ? false : true,
//           onPressed: changeRankingType,
//         ),
//         SizedBox(width: 20),
//
//         /// 전체 랭킹 버튼
//         RankingTypeBotton(
//           text: '전체',
//           active: rankingType == RankingType.all ? false : true,
//           onPressed: changeRankingType,
//         ),
//       ],
//     );
//   }
// }
//
// class RankingTypeBotton extends StatelessWidget {
//   final String text;
//   final bool active;
//   final void Function()? onPressed;
//
//   const RankingTypeBotton({
//     super.key,
//     required this.text,
//     required this.active,
//     this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     const double widthRatio = 5;
//     const double heightRatio = 2;
//     const double buttonScale = 17;
//     return SizedBox(
//       width: widthRatio * buttonScale,
//       height: heightRatio * buttonScale,
//       child: FilledButton(
//         style: FilledButton.styleFrom(
//           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//           backgroundColor: Color(0xFFE0E0E0),
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: Theme.of(context).colorScheme.primary,
//           disabledForegroundColor: Colors.white,
//           textStyle: GoogleFonts.inter(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         onPressed: active ? onPressed : null,
//         child: Text(text),
//       ),
//     );
//   }
// }
//
// /// 주차 및 기수 변경 위젯
// class RankingTurnGroup extends StatelessWidget {
//   final RankingType rankingType;
//   final int rankingWeek;
//   final int rankingGeneration;
//   final PageController weeklyRankingPagecontroller;
//   final PageController allRankingPagecontroller;
//
//   const RankingTurnGroup({
//     super.key,
//     required this.rankingType,
//     required this.rankingWeek,
//     required this.rankingGeneration,
//     required this.weeklyRankingPagecontroller,
//     required this.allRankingPagecontroller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // 현재 표시 중인 랭킹의 주차 또는 기수 정보
//     final String nowRanking = switch (rankingType) {
//       RankingType.weekly => '$rankingWeek주차',
//       RankingType.all => '$rankingGeneration기',
//     };
//     // arrow icon size
//     double arrowIconSize = SizeConfig.safeBlockHorizontal * 4.2;
//
//     return SizedBox(
//       width: double.maxFinite,
//       height: SizeConfig.safeBlockVertical * 4,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           IconButton(
//             visualDensity: VisualDensity.compact,
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               if (rankingType == RankingType.weekly) {
//                 weeklyRankingPagecontroller.previousPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.ease,
//                 );
//               } else {
//                 allRankingPagecontroller.previousPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.ease,
//                 );
//               }
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new,
//               color: Color(0xFF7B7B7B),
//               size: arrowIconSize,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.zero,
//             padding: EdgeInsets.zero,
//             alignment: Alignment.center,
//             width: SizeConfig.safeBlockHorizontal * 55,
//             child: Text(
//               nowRanking,
//               style: TextStyle(
//                 fontSize: SizeConfig.safeBlockHorizontal * 4.5,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF7B7B7B),
//               ),
//             ),
//           ),
//           IconButton(
//             padding: EdgeInsets.zero,
//             visualDensity: VisualDensity.compact,
//             onPressed: () {
//               if (rankingType == RankingType.weekly) {
//                 weeklyRankingPagecontroller.nextPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.ease,
//                 );
//               } else {
//                 allRankingPagecontroller.nextPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.ease,
//                 );
//               }
//             },
//             icon: Icon(
//               Icons.arrow_forward_ios,
//               color: Color(0xFF7B7B7B),
//               size: arrowIconSize,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// 랭킹 기준 안내 버튼
// class RankingCriteriaButton extends StatelessWidget {
//   const RankingCriteriaButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0.3),
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
//       alignment: Alignment.centerRight,
//       width: double.maxFinite,
//       height: SizeConfig.safeBlockVertical * 3.0,
//       child: TextButton.icon(
//         style: TextButton.styleFrom(
//           padding: EdgeInsets.zero,
//           alignment: Alignment.bottomCenter,
//         ),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (_) => RankingCriteriaPopup(),
//           );
//         },
//         icon: SvgPicture.asset(
//           'assets/icons/question_mark_circle.svg',
//           color: Color(0xFFE0E0E0),
//           width: SizeConfig.safeBlockHorizontal * 2.75,
//         ),
//         label: Text(
//           '랭킹 기준',
//           style: GoogleFonts.inter(
//             textStyle: TextStyle(
//               color: Color(0xFFE0E0E0),
//               fontSize: SizeConfig.safeBlockHorizontal * 2.75,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// 랭킹 기준 안내 팝업창
// class RankingCriteriaPopup extends StatelessWidget {
//   const RankingCriteriaPopup({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("랭킹 기준"),
//       content: Text(
//         "본인의 난이도 문제: 1점\n본인의 난이도보다 낮은 문제: 0.5점\n본인의 난이도보다 높은 문제: 2점",
//         style: TextStyle(color: Color(0xFF7B7B7B)),
//       ),
//       backgroundColor: Color(0xFFFFFFFF),
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }
// }
//
// /// 랭킹 요소 구분
// class RankingCategoryIndicator extends StatelessWidget {
//   const RankingCategoryIndicator({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 10 / 1,
//       child: Row(
//         children: [
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 24.4),
//           _textBox("프로필", SizeConfig.safeBlockHorizontal * 7.778),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 30.27),
//           _textBox("총점", SizeConfig.safeBlockHorizontal * 5.278),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 12.77),
//           _textBox("순위", SizeConfig.safeBlockHorizontal * 5.278),
//         ],
//       ),
//     );
//   }
//
//   Widget _textBox(String str, double width) {
//     return SizedBox(
//       width: width,
//       child: FittedBox(
//         fit: BoxFit.fitWidth,
//         child: Text(
//           str,
//           style: GoogleFonts.inter(color: Color(0xFF7B7B7B)),
//         ),
//       ),
//     );
//   }
// }
//
// /// 주간 랭킹 페이지 뷰
// class WeeklyRankingPageView extends StatelessWidget {
//   final int weekOffset;
//   final int selectedWeek;
//   final void Function(int) changeWeek;
//   final PageController pageController;
//   final Future<WeeklyRankingsListDTO> futureWeeklyRankingsList;
//
//   const WeeklyRankingPageView({
//     super.key,
//     required this.weekOffset,
//     required this.selectedWeek,
//     required this.changeWeek,
//     required this.pageController,
//     required this.futureWeeklyRankingsList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WeeklyRankingsListDTO>(
//       future: futureWeeklyRankingsList,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final WeeklyRankingsListDTO body = snapshot.data!;
//           return Expanded(
//             child: PageView.builder(
//               controller: pageController,
//               onPageChanged: (int page) {
//                 changeWeek(page);
//               },
//               itemCount: body.data.length,
//               itemBuilder: (context, index) =>
//                   _pageItem(body.getWeeklyRanking(index + weekOffset)),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Expanded(
//             child: Center(
//               child: Text('에러 발생. 운영진에게 제보 바랍니다.'),
//             ),
//           );
//         }
//
//         // By default, show a loading spinner.
//         return Expanded(
//           child: Center(
//             child: const CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _pageItem(WeeklyRankingsDTO? rankingData) {
//     if (rankingData == null) {
//       return Text("No data");
//     }
//     return RankingList(rankings: rankingData.rankings);
//   }
// }
//
// /// 전체 랭킹 페이지 뷰
// class AllRankingPageView extends StatelessWidget {
//   final int generationOffset;
//   final int selectedGeneration;
//   final void Function(int) changeGeneration;
//   final PageController pageController;
//   final Future<OverallRankingsListDTO> futureOverallRankingsList;
//
//   const AllRankingPageView({
//     super.key,
//     required this.generationOffset,
//     required this.selectedGeneration,
//     required this.changeGeneration,
//     required this.pageController,
//     required this.futureOverallRankingsList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<OverallRankingsListDTO>(
//       future: futureOverallRankingsList,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final OverallRankingsListDTO body = snapshot.data!;
//           return Expanded(
//             child: PageView.builder(
//               controller: pageController,
//               onPageChanged: (int page) {
//                 changeGeneration(page);
//               },
//               itemCount: body.data.length,
//               itemBuilder: (context, index) => _pageItem(
//                   body.getGenerationRanking(index + generationOffset)),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           debugPrint(snapshot.error.toString());
//           return Expanded(
//             child: Center(
//               child: Text('에러 발생. 운영진에게 제보 바랍니다.'),
//             ),
//           );
//         }
//
//         // By default, show a loading spinner.
//         return Expanded(
//           child: Center(
//             child: const CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _pageItem(OverallRankingsDTO? rankingData) {
//     if (rankingData == null) {
//       return Text("No data");
//     }
//     return RankingList(rankings: rankingData.rankings);
//   }
// }
//
// /// 랭킹 목록
// class RankingList<T> extends StatelessWidget {
//   final List<T> rankings;
//
//   RankingList({
//     super.key,
//     required this.rankings,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.safeBlockHorizontal * 2.778,
//       ),
//       itemCount: rankings.length,
//       itemBuilder: (BuildContext context, int index) =>
//           listItem(context, index),
//     );
//   }
//
//   Widget listItem(BuildContext context, int index) {
//     return MemberRankingCard(
//         memberRankingData: rankings[index] as MemberRankingInfoDTO);
//   }
// }
//
// /// 랭킹 목록 요소
// class MemberRankingCard extends StatelessWidget {
//   final MemberRankingInfoDTO memberRankingData;
//
//   final String _profileImageUrl;
//   final String _name;
//   final Location _location;
//   final String _generation;
//   final Level _level;
//   final double _score;
//   final int _rank;
//
//   MemberRankingCard({
//     super.key,
//     required this.memberRankingData,
//   })  : _profileImageUrl =
//             'assets/profiles/profile_${memberRankingData.profileImg}.svg',
//         _name = memberRankingData.username,
//         _location = memberRankingData.location,
//         _generation = memberRankingData.generation,
//         _level = memberRankingData.level,
//         _score = memberRankingData.score,
//         _rank = memberRankingData.rank;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: SizeConfig.safeBlockHorizontal * 1.389),
//       padding: EdgeInsets.all(0),
//       child: AspectRatio(
//         aspectRatio: 17 / 3,
//         child: Card(
//           margin: EdgeInsets.all(0),
//           elevation: 0,
//           color: Color(0xFFFFFFFF),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(7),
//             side: BorderSide(
//               color: Color(0xFFE0E0E0),
//               width: SizeConfig.safeBlockHorizontal * 0.3278,
//             ),
//           ),
//           child: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//             final double cardBlockSizeHorizontal = constraints.maxWidth / 100.0;
//             final double cardBlockSizeVertical = constraints.maxHeight / 100.0;
//             return Stack(
//               alignment: Alignment.centerLeft,
//               children: [
//                 /// 프로필 이미지
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 4.118,
//                   child: SizedBox(
//                     width: cardBlockSizeVertical * 81.67,
//                     height: cardBlockSizeVertical * 81.67,
//                     child: FittedBox(
//                       fit: BoxFit.fill,
//                       child: SvgPicture.asset(
//                         _profileImageUrl,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// 프로필
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 21.47,
//                   child: SizedBox(
//                     height: cardBlockSizeVertical * 100.0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: cardBlockSizeVertical * 18.33,
//                         ),
//
//                         /// 이름, 지점
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(
//                                   right: cardBlockSizeHorizontal * 2.647),
//                               child: Text(
//                                 _name,
//                                 style: TextStyle(
//                                   fontSize:
//                                       SizeConfig.safeBlockHorizontal * 3.0,
//                                   color: Color(0xFF000000),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               Location.toName[_location] ?? "No data",
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 2.0,
//                                 color: Color(0xFF878787),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: cardBlockSizeVertical * 10),
//
//                         /// 기수, 난이도
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: cardBlockSizeVertical * 26.67,
//                               width: cardBlockSizeHorizontal * 8.824,
//                               alignment: Alignment.center,
//                               decoration: ShapeDecoration(
//                                 shape: RoundedRectangleBorder(
//                                   side: BorderSide(
//                                     width: SizeConfig.safeBlockHorizontal * 0.2,
//                                     color: Color(0xFFE0E0E0),
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: Text(
//                                 _generation,
//                                 style: GoogleFonts.roboto(
//                                   fontSize:
//                                       SizeConfig.safeBlockHorizontal * 2.0,
//                                   color: Color(0xFF7B7B7B),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: cardBlockSizeHorizontal * 0.8824),
//                             Container(
//                               height: cardBlockSizeVertical * 26.67,
//                               width: cardBlockSizeHorizontal * 10.29,
//                               alignment: Alignment.center,
//                               decoration: ShapeDecoration(
//                                 shape: RoundedRectangleBorder(
//                                   side: BorderSide(
//                                     width: SizeConfig.safeBlockHorizontal * 0.2,
//                                     color: Color(0xFFE0E0E0),
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: Text(
//                                 Level.toName[_level] ?? 'No data',
//                                 style: GoogleFonts.roboto(
//                                   fontSize:
//                                       SizeConfig.safeBlockHorizontal * 2.0,
//                                   color: Color(0xFF7B7B7B),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 /// 총점
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 60,
//                   child: Container(
//                     alignment: Alignment.center,
//                     width: cardBlockSizeHorizontal * 12,
//                     child: Text(
//                       '$_score점',
//                       style: GoogleFonts.roboto(
//                         fontSize: cardBlockSizeHorizontal * 3.0,
//                         color: Color(0xFF7B7B7B),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// 순위
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 80.55,
//                   child: Container(
//                     width: cardBlockSizeHorizontal * 9.0,
//                     alignment: Alignment.center,
//                     child: Text(
//                       '$_rank',
//                       style: GoogleFonts.roboto(
//                         fontSize: cardBlockSizeHorizontal * 3,
//                         color: Color(0xFF000000),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// 왕관
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 87.0,
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 1),
//                     alignment: Alignment.centerLeft,
//                     child: switch (_rank) {
//                       1 => SvgPicture.asset(
//                           'assets/icons/crown_gold.svg',
//                           width: cardBlockSizeHorizontal * 2.4,
//                         ),
//                       2 => SvgPicture.asset(
//                           'assets/icons/crown_silver.svg',
//                           width: cardBlockSizeHorizontal * 2.4,
//                         ),
//                       3 => SvgPicture.asset(
//                           'assets/icons/crown_bronze.svg',
//                           width: cardBlockSizeHorizontal * 2.4,
//                         ),
//                       _ => null,
//                     },
//                   ),
//                 )
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
