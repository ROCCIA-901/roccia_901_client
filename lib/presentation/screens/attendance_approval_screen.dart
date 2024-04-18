// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:untitled/utils/dialog_helper.dart';
//
// import '/constants/size_config.dart';
//
// /// 확인 창에서 반환되는 값
// enum _ConfirmPopupResult {
//   accept, // 출석 허가
//   reject, // 출석 거절
//   cancel, // 선택 취소
// }
//
// /*
// 1. future builder를 통해 출석 리스트를 가져오기가 완료되면,
// 1-1. 출석 리스트와 size가 같은 List<bool>을 생성 후 기본값을 false로 초기화.
// 2. bool list가 false인 index만 표시.
//
// 1. 승인 or 거절 버튼을 누른다.
// 2. 해당하는 index의 bool list를 true로 변경.
// 3. setState.
//  */
//
// class AttendanceApprovalScreen extends StatefulWidget {
//   const AttendanceApprovalScreen({super.key});
//
//   @override
//   State<AttendanceApprovalScreen> createState() =>
//       _AttendanceApprovalScreenState();
// }
//
// class _AttendanceApprovalScreenState extends State<AttendanceApprovalScreen> {
//   // 서버에서 받아올 출석 목록 데이터의 Future
//   // 비동기 작업이 끝났는지 확인하는 작업만 담당한다.
//   late final Future<AttendanceRequestsDTO> futureAttendanceRequests;
//   // 실제 사용할 출석 목록 데이터.
//   // 처리된 출석 요청은 삭제된다.
//   late final List<AttendanceRequestDTO> attendanceRequests;
//
//   @override
//   void initState() {
//     super.initState();
//     futureAttendanceRequests = _asyncInit();
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
//             'assets/titles/attendance_approval_title.svg',
//             color: Color(0xFF000000),
//             height: SizeConfig.safeBlockVertical * 5,
//           ),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// "출석 요청 목록" Text
//             Container(
//               width: double.maxFinite,
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.only(
//                 top: SizeConfig.safeBlockVertical * 4,
//               ),
//               padding: EdgeInsets.only(
//                 left: SizeConfig.safeBlockHorizontal * 6.667,
//               ),
//               child: Text(
//                 "출석 요청 목록",
//                 style: GoogleFonts.inter(
//                   fontSize: SizeConfig.safeBlockHorizontal * 3.3,
//                   color: Color(0xFF9A9A9A),
//                 ),
//               ),
//             ),
//
//             /// 출석 요청 카테고리
//             AttendanceRequestCategory(),
//
//             /// 출석 요청 목록
//             FutureBuilder(
//               future: futureAttendanceRequests,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return AttendanceRequestList(
//                     dataList: attendanceRequests,
//                     acceptAttendanceRequest: _acceptAttendanceRequest,
//                     rejectAttendanceRequest: _rejectAttendanceRequest,
//                   );
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
//   Future<AttendanceRequestsDTO> _asyncInit() async {
//     final AttendanceRequestsDTO attendanceRequests =
//         await AttendanceRequestsService().fetch();
//     debugPrint(attendanceRequests.detail);
//     this.attendanceRequests = attendanceRequests.data;
//     return attendanceRequests;
//   }
//
//   void _showApiErrorSnackBar(BuildContext context) {
//     ScaffoldMessenger.of(context)
//       ..removeCurrentSnackBar()
//       ..showSnackBar(SnackBar(content: Text('에러 발생. 운영진에게 문의바랍니다.')));
//   }
//
//   Future<void> _acceptAttendanceRequest(
//       int requestId, int index, BuildContext context) async {
//     // 로딩 스피너
//     DialogHelper.showLoaderDialog(context);
//     if (!context.mounted) return;
//     // patch
//     try {
//       final body = await AttendanceRequestAcceptService().update(requestId);
//       debugPrint(body.detail);
//       setState(() {
//         // isRequestProcessed[index] = true;
//         this.attendanceRequests.removeAt(index);
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       if (context.mounted) _showApiErrorSnackBar(context);
//     } finally {
//       if (context.mounted) Navigator.pop(context);
//     }
//   }
//
//   void _rejectAttendanceRequest(
//       int requestId, int index, BuildContext context) async {
//     // 로딩 스피너
//     DialogHelper.showLoaderDialog(context);
//
//     // patch
//     try {
//       final body = await AttendanceRequestRejectService().update(requestId);
//       debugPrint(body.detail);
//       setState(() {
//         // isRequestProcessed[index] = true;
//         this.attendanceRequests.removeAt(index);
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       if (context.mounted) _showApiErrorSnackBar(context);
//     } finally {
//       // 로딩 스피너 닫기
//       if (context.mounted) Navigator.pop(context);
//     }
//   }
// }
//
// /// 출석 요청 카테고리
// class AttendanceRequestCategory extends StatelessWidget {
//   const AttendanceRequestCategory({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 10 / 1,
//       child: Row(
//         children: [
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 23.33),
//           _textBox("프로필", SizeConfig.safeBlockHorizontal * 2.8),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 25.11),
//           _textBox("요청 시간", SizeConfig.safeBlockHorizontal * 2.8),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 8.0),
//           _textBox("승인", SizeConfig.safeBlockHorizontal * 2.8),
//           SizedBox(width: SizeConfig.safeBlockHorizontal * 5.6),
//           _textBox("거절", SizeConfig.safeBlockHorizontal * 2.8),
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
// /// 출석 요청 목록
// class AttendanceRequestList extends StatelessWidget {
//   final List<AttendanceRequestDTO> dataList;
//   final Function acceptAttendanceRequest;
//   final Function rejectAttendanceRequest;
//
//   const AttendanceRequestList({
//     super.key,
//     required this.dataList,
//     required this.acceptAttendanceRequest,
//     required this.rejectAttendanceRequest,
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
//         itemBuilder: (BuildContext context, int index) => _listItem(index),
//       ),
//     );
//   }
//
//   Widget? _listItem(int index) {
//     return MemberAttendanceRequestCard(
//       data: dataList[index],
//       index: index,
//       acceptAttendanceRequest: acceptAttendanceRequest,
//       rejectAttendanceRequest: rejectAttendanceRequest,
//     );
//   }
// }
//
// /// 멤버 출석 요청 card
// class MemberAttendanceRequestCard extends StatelessWidget {
//   final AttendanceRequestDTO data;
//   final int index;
//   final Function acceptAttendanceRequest;
//   final Function rejectAttendanceRequest;
//
//   final String _profileImageUrl;
//   final String _name;
//   final Location _location;
//   final String _generation;
//   final Level _level;
//   final DateTime _time;
//
//   MemberAttendanceRequestCard({
//     super.key,
//     required this.data,
//     required this.index,
//     required this.acceptAttendanceRequest,
//     required this.rejectAttendanceRequest,
//   })  : _profileImageUrl = 'assets/profiles/profile_${data.profileImg}.svg',
//         _name = data.username,
//         _location = data.location,
//         _generation = data.generation,
//         _level = data.level,
//         _time = DateTime.parse(data.requestTime);
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
//                               Location.toName[_location] ?? "",
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
//                                 Level.toName[_level] ?? "",
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
//                 /// 요청 시간
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 56.7,
//                   child: Container(
//                     alignment: Alignment.center,
//                     width: cardBlockSizeHorizontal * 12,
//                     child: Text(
//                       '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}',
//                       style: GoogleFonts.roboto(
//                         fontSize: cardBlockSizeHorizontal * 3.0,
//                         color: Color(0xFF7B7B7B),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// 승인 아이콘 버튼
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 74.7,
//                   child: Container(
//                     width: cardBlockSizeHorizontal * 11,
//                     height: cardBlockSizeHorizontal * 11,
//                     padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
//                     alignment: Alignment.center,
//                     child: IconButton(
//                       padding: EdgeInsets.all(0),
//                       icon: SvgPicture.asset(
//                         'assets/icons/check_circle.svg',
//                         width: cardBlockSizeHorizontal * 6,
//                         color: Color(0xFFCAE4C1),
//                       ),
//                       onPressed: () {
//                         confirmChoice(context, true);
//                       },
//                     ),
//                   ),
//                 ),
//
//                 /// 거절 아이콘 버튼
//                 Positioned(
//                   left: cardBlockSizeHorizontal * 86,
//                   child: Container(
//                     width: cardBlockSizeHorizontal * 11,
//                     height: cardBlockSizeHorizontal * 11,
//                     padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
//                     alignment: Alignment.center,
//                     child: IconButton(
//                       padding: EdgeInsets.all(0),
//                       icon: SvgPicture.asset(
//                         'assets/icons/cancel_circle.svg',
//                         width: cardBlockSizeHorizontal * 6,
//                         color: Color(0xFFEA7373),
//                       ),
//                       onPressed: () {
//                         confirmChoice(context, false);
//                       },
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
//
//   Future<void> confirmChoice(BuildContext context, bool isAccept) async {
//     final result = await showDialog(
//       context: context,
//       builder: (_) => ConfirmPopup(isAccept: isAccept),
//     );
//     switch (result) {
//       case (_ConfirmPopupResult.accept):
//         if (context.mounted) {
//           acceptAttendanceRequest(data.requestId, index, context);
//         }
//         break;
//       case (_ConfirmPopupResult.reject):
//         if (context.mounted) {
//           rejectAttendanceRequest(data.requestId, index, context);
//         }
//         break;
//       case (_ConfirmPopupResult.cancel):
//         break;
//     }
//   }
// }
//
// class ConfirmPopup extends StatelessWidget {
//   // true: 승인, false: 거절
//   final bool isAccept;
//
//   const ConfirmPopup({
//     super.key,
//     required this.isAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Text(
//         "출석을 ${isAccept ? '승인' : '거절'} 하시겠습니까?",
//         textAlign: TextAlign.center,
//       ),
//       contentTextStyle: GoogleFonts.inter(
//         fontSize: SizeConfig.safeBlockHorizontal * 3.4,
//         color: Color(0xFF000000),
//       ),
//       contentPadding: EdgeInsets.only(
//         top: SizeConfig.safeBlockVertical * 5,
//         bottom: SizeConfig.safeBlockVertical * 2.5,
//       ),
//       actions: <Widget>[
//         ConfirmPopupButton(
//           isOk: false,
//           backgroundColor: Color(0xFFF2F2F2),
//           onPressed: popDialog,
//         ),
//         ConfirmPopupButton(
//           isOk: true,
//           backgroundColor: isAccept ? Color(0xFFCAE4C1) : Color(0xFFEA7373),
//           onPressed: popDialog,
//         ),
//       ],
//       actionsAlignment: MainAxisAlignment.center,
//       actionsPadding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 3),
//       backgroundColor: Color(0xFFFFFFFF),
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       buttonPadding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.safeBlockHorizontal * 3,
//       ),
//     );
//   }
//
//   void popDialog(BuildContext context, bool isOk) {
//     late final _ConfirmPopupResult result;
//     if (isOk) {
//       if (isAccept) {
//         result = _ConfirmPopupResult.accept;
//       } else {
//         result = _ConfirmPopupResult.reject;
//       }
//     } else {
//       result = _ConfirmPopupResult.cancel;
//     }
//     Navigator.pop(context, result);
//   }
// }
//
// class ConfirmPopupButton extends StatelessWidget {
//   // true: 예, false:아니오
//   final bool isOk;
//   final Color backgroundColor;
//   final void Function(BuildContext context, bool isOk) onPressed;
//
//   const ConfirmPopupButton({
//     super.key,
//     required this.isOk,
//     required this.backgroundColor,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double width = SizeConfig.safeBlockHorizontal * 19.44;
//     final double height = width * 3 / 7;
//     return SizedBox(
//       width: width,
//       height: height,
//       child: FilledButton(
//         style: FilledButton.styleFrom(
//           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//           backgroundColor: backgroundColor,
//           textStyle: GoogleFonts.inter(
//             fontSize: SizeConfig.safeBlockHorizontal * 2.5,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         onPressed: () {
//           onPressed(context, isOk);
//         },
//         child: Text(
//           isOk ? '예' : '아니오',
//           style: TextStyle(
//             color: isOk ? Colors.white : Color(0xFFD1D3D9),
//           ),
//         ),
//       ),
//     );
//   }
// }
