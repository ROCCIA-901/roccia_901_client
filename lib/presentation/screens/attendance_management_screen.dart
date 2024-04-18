// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:untitled/dto/home/user_attendance_rate_list_dto.dart';
// import 'package:untitled/services/home/user_attendance_rate_list_service.dart';
//
// import '../config/app_constants.dart';
// import '../config/size_config.dart';
//
// /* Todo
// 1. 유저 출석율 목록 지점별로 정렬.
// 2.
//  */
//
// class AttendanceManagementScreen extends StatefulWidget {
//   const AttendanceManagementScreen({super.key});
//
//   @override
//   State<AttendanceManagementScreen> createState() =>
//       _AttendanceManagementScreenState();
// }
//
// class _AttendanceManagementScreenState
//     extends State<AttendanceManagementScreen> {
//   // async 함수의 실행 완료 유무를 파악하기 위한 변수
//   late final Future<void> _asyncInitResult;
//   // 유저들의 출석 목록
//   // null 요소는 지점이 새롭게 시작되는 부분을 의미한다.
//   late final List<UserAttendanceRateDTO?> userAttendanceRates;
//
//   @override
//   void initState() {
//     super.initState();
//     _asyncInitResult = _asyncInit();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: SvgPicture.asset(
//             'assets/titles/attendance_management_title.svg',
//             color: Color(0xFF000000),
//             height: SizeConfig.safeBlockVertical * 5,
//           ),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// "부원 목록" Text
//             Container(
//               width: double.maxFinite,
//               height: SizeConfig.safeBlockVertical * 3.5,
//               alignment: Alignment.topLeft,
//               margin: EdgeInsets.only(
//                 top: SizeConfig.safeBlockVertical * 4,
//               ),
//               padding: EdgeInsets.only(
//                 left: SizeConfig.safeBlockHorizontal * 6.667,
//               ),
//               child: Text(
//                 "부원 목록",
//                 style: GoogleFonts.inter(
//                   fontSize: SizeConfig.safeBlockHorizontal * 3.3,
//                   color: Color(0xFF9A9A9A),
//                 ),
//               ),
//             ),
//
//             /// 출석 정보 목록
//             FutureBuilder(
//               future: _asyncInitResult,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return AttendanceManagementList(
//                       dataList: userAttendanceRates);
//                 } else if (snapshot.hasError) {
//                   debugPrint(snapshot.error.toString());
//                   return Expanded(
//                     child: Center(
//                       child: Text('에러 발생. 운영진에게 제보 바랍니다.'),
//                     ),
//                   );
//                 }
//
//                 // By default, show a loading spinner.
//                 return Expanded(
//                   child: Center(
//                     child: const CircularProgressIndicator(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _asyncInit() async {
//     final userAttendanceRateListDTO =
//         await UserAttendanceRateListService().fetch();
//     debugPrint(userAttendanceRateListDTO.detail);
//     this.userAttendanceRates = List.from(userAttendanceRateListDTO.data);
//     this
//         .userAttendanceRates
//         .sort((a, b) => b!.location.index - a!.location.index);
//     _insertLocalClassifier();
//   }
//
//   void _insertLocalClassifier() {
//     Location? curLocation;
//     int i = 0;
//     // length를 밖으로 빼지 마세요.
//     // 요소 insert가 loop에서 발생할 수 있어 항상 새로 length를 받아야 합니다.
//     while (i < this.userAttendanceRates.length) {
//       if (curLocation != this.userAttendanceRates[i]!.location) {
//         curLocation = this.userAttendanceRates[i]!.location;
//         this.userAttendanceRates.insert(i, null);
//         i++;
//       }
//       i++;
//     }
//   }
// }
//
// /// 출석 정보 목록
// class AttendanceManagementList extends StatelessWidget {
//   final List<UserAttendanceRateDTO?> dataList;
//
//   const AttendanceManagementList({
//     super.key,
//     required this.dataList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         padding: EdgeInsets.symmetric(
//           horizontal: SizeConfig.safeBlockHorizontal * 2.778,
//         ),
//         itemCount: dataList.length,
//         itemBuilder: (BuildContext context, int index) {
//           if (dataList[index] == null) {
//             return Column(
//               children: [
//                 PlaceIndex(
//                     place:
//                         Location.toName[dataList[index + 1]!.location] ?? ""),
//                 AttendanceManagementCategory(),
//               ],
//             );
//           }
//           return listItem(index);
//         },
//       ),
//     );
//   }
//
//   Widget listItem(int index) {
//     return MemberAttendanceCard(
//       data: dataList[index]!,
//     );
//   }
// }
//
// /// 지점 Text
// class PlaceIndex extends StatelessWidget {
//   final String place;
//
//   const PlaceIndex({
//     super.key,
//     required this.place,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.maxFinite,
//       height: SizeConfig.safeBlockVertical * 5,
//       alignment: Alignment.bottomLeft,
//       margin: EdgeInsets.all(0),
//       padding: EdgeInsets.only(
//         left: SizeConfig.safeBlockHorizontal * 4,
//       ),
//       child: Text(
//         '$place지점',
//         style: GoogleFonts.inter(
//           fontSize: SizeConfig.safeBlockHorizontal * 3.3,
//           fontWeight: FontWeight.normal,
//           color: Color(0xFF000000),
//         ),
//       ),
//     );
//   }
// }
//
// /// 부원 출석 정보 카테고리
// class AttendanceManagementCategory extends StatelessWidget {
//   const AttendanceManagementCategory({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 10 / 1,
//       child: Row(
//         children: [
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 20.55),
//           _textBox("프로필", SizeConfig.safeBlockHorizontal * 2.8),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 30.0),
//           _textBox("출석률", SizeConfig.safeBlockHorizontal * 2.8),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 13.0),
//           _textBox("상세 보기", SizeConfig.safeBlockHorizontal * 2.8),
//         ],
//       ),
//     );
//   }
//
//   Widget _textBox(String str, double fontSize) {
//     return SizedBox(
//       child: Text(
//         str,
//         style: GoogleFonts.inter(
//           fontSize: fontSize,
//           color: Color(0xFF7B7B7B),
//         ),
//       ),
//     );
//   }
// }
//
// /// 부원 출석 정보 카드
// class MemberAttendanceCard extends StatelessWidget {
//   final UserAttendanceRateDTO data;
//
//   final String _profileImageUrl;
//   final String _name;
//   final String _location;
//   final String _generation;
//   final String _level;
//   final String _attendanceRate;
//
//   MemberAttendanceCard({
//     super.key,
//     required this.data,
//   })  : _profileImageUrl = 'assets/profiles/profile_${data.profileImg}.svg',
//         _name = data.username,
//         _location = Location.toName[data.location] ?? "",
//         _generation = data.generation,
//         _level = Level.toName[data.level] ?? "",
//         _attendanceRate = '${data.attendanceRate}%';
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
//                               _location,
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
//                                 _level,
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
//                 /// 출석률
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 60.2,
//                   child: Container(
//                     alignment: Alignment.center,
//                     width: cardBlockSizeHorizontal * 12,
//                     child: Text(
//                       _attendanceRate,
//                       style: GoogleFonts.roboto(
//                         fontSize: cardBlockSizeHorizontal * 3.3,
//                         color: Color(0xFF7B7B7B),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// 돋보기 아이콘 버튼
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 84.5,
//                   child: Container(
//                     width: cardBlockSizeHorizontal * 11,
//                     height: cardBlockSizeHorizontal * 11,
//                     padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
//                     alignment: Alignment.center,
//                     child: IconButton(
//                       padding: EdgeInsets.all(0),
//                       icon: SvgPicture.asset(
//                         'assets/icons/magnifying_glass.svg',
//                         width: cardBlockSizeHorizontal * 6,
//                         color: Color(0xFFCAE4C1),
//                       ),
//                       onPressed: () {},
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
