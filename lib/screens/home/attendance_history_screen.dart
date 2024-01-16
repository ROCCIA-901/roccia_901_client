import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';


class AttendanceHistoryScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AttendanceHistoryScreen> {
  Map<String, double> dataMap = {
    "출석": 3,
    "지각": 1,
    "결석": 1
  };
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
                            'assets/icons/atd_history_back.svg',
                            height: 50,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 40),
                      child: Text(
                        "출석 종합",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9a9a9a)
                        ),
                      ),
                      width: 150,
                      height: 80,
                    ),
                    Container(
                      child: Center(
                        child: PieChart(
                          dataMap: dataMap,
                          animationDuration: Duration(milliseconds: 1500),
                          colorList: [
                            Color(0xffcae4c1),
                            Color(0xffffe200),
                            Color(0xffea7373)
                          ],
                          chartRadius: MediaQuery.of(context).size.width / 1.2,
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.bottom,
                            showLegendsInRow: true,
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: false
                          ),
                        ),
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }
}