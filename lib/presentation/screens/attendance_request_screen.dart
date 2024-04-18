import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/size_config.dart';

class AttendanceRequestScreen extends StatefulWidget {
  const AttendanceRequestScreen({super.key});

  @override
  State createState() => _AttendanseRequestState();
}

class _AttendanseRequestState extends State<AttendanceRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/titles/attendance_request_title.svg',
            color: Color(0xFF000000),
            height: SizeConfig.safeBlockVertical * 5,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 8),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        color: Colors.black),
                    children: [
                      TextSpan(text: "   오늘은 "),
                      TextSpan(
                        text: "양재",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " 지점에서 운동하는 날입니다!"),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 3.5,
                    top: SizeConfig.safeBlockVertical * 10),
                child: Text(
                  "내 출석률",
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 3.3,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 50,
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: SvgPicture.asset(
                    'assets/buttons/attendance_request_button.svg',
                    width: SizeConfig.safeBlockHorizontal * 80,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
