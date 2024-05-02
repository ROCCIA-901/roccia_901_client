import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../constants/size_config.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  SizeConfig _sizeConfig = SizeConfig();

  Map<String, double> dataMap = {"출석": 3, "지각": 1, "결석": 1};
  @override
  Widget build(BuildContext context) {
    _sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/titles/attendance_history_title.svg',
            color: Color(0xFF000000),
            height: _sizeConfig.safeBlockVertical * 5,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: _sizeConfig.safeBlockHorizontal * 9,
                top: _sizeConfig.safeBlockVertical * 5,
                bottom: _sizeConfig.safeBlockVertical * 6,
              ),
              child: Text(
                "출석 종합",
                style: TextStyle(
                  fontSize: _sizeConfig.safeBlockHorizontal * 3.5,
                  color: Color(0xff9a9a9a),
                ),
              ),
            ),
            Center(
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 1500),
                colorList: [
                  Color(0xffcae4c1),
                  Color(0xffffe200),
                  Color(0xffea7373)
                ],
                chartRadius: _sizeConfig.safeBlockHorizontal * 50,
                legendOptions: LegendOptions(
                  legendPosition: LegendPosition.bottom,
                  showLegendsInRow: true,
                ),
                chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: false, showChartValues: false),
              ),
            )
          ],
        ),
      ),
    );
  }
}
