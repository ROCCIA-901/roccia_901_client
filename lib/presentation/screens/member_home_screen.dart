// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:untitled/screens/attendance_request_screen.dart';
// import 'package:untitled/screens/attendance_history_screen.dart';
//
// class MemberHomeScreen extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MemberHomeScreen> {
//   DateTime today = DateTime.now();
//   void _onDaySelected(DateTime day, DateTime focusDay) {
//     setState(() {
//       today = day;
//     });
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//       child: Container(
//         padding: EdgeInsets.only(left: 20, right: 20, top: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               child: Text(
//                 '홈',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               width: 100,
//               height: 60,
//             ),
//             Container(
//               child: SvgPicture.asset(
//                 'assets/banners/howto.svg',
//                 height: 100,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 15),
//               child: Text(
//                 '출석',
//                 style: TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
//               ),
//               width: 100,
//               height: 50,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(right: 12),
//                   child: InkWell(
//                     child: SvgPicture.asset(
//                       'assets/icons/atd.svg',
//                       height: 82,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AttendanceRequestScreen()));
//                     },
//                   ),
//                 ),
//                 Container(
//                   child: InkWell(
//                     child: SvgPicture.asset(
//                       'assets/icons/atd_history.svg',
//                       height: 82,
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AttendanceHistoryScreen()));
//                     },
//                   ),
//                 )
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20),
//               child: Text(
//                 '출석 현황',
//                 style: TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
//               ),
//               width: 100,
//               height: 40,
//             ),
//             TableCalendar(
//               focusedDay: today,
//               selectedDayPredicate: (day) => isSameDay(day, today),
//               firstDay: DateTime(2015),
//               lastDay: DateTime(2050),
//               locale: 'ko-KR',
//               onDaySelected: _onDaySelected,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//               ),
//               calendarStyle: CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                     color: Colors.transparent,
//                     border: Border(
//                         bottom:
//                             BorderSide(width: 3, color: Color(0xff7b7b7b)))),
//                 todayTextStyle:
//                     TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                 selectedDecoration: BoxDecoration(
//                     color: Color(0xffcae4c1), shape: BoxShape.circle),
//                 selectedTextStyle: TextStyle(color: Colors.white),
//                 outsideDaysVisible: false,
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
