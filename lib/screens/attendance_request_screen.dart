import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AttendanceRequestScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AttendanceRequestScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/atd_back.svg',
                        height: 50,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                    Container(
                      height: 120,
                      width: 10,
                      color: Colors.transparent,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                          TextSpan(text: "   오늘은 "),
                          TextSpan(
                              text: "양재",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: " 지점에서 운동하는 날입니다!")
                        ])),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 120),
                      child: Text(
                        "내 출석률",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff9a9a9a)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                    Container(
                      height: 300,
                      width: 10,
                      color: Colors.transparent,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: SvgPicture.asset(
                          'assets/icons/atd_button.svg',
                          height: 60,
                        ),
                      ),
                    )
                  ]))),
    );
  }
}
