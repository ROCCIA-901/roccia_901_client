import 'package:flutter/material.dart';


class CompetitionScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CompetitionScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '대회',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 100,
                height: 60,
              ),
              Container(
                height: 600,
                alignment: Alignment.center,
                child: Text(
                  "대회 기간에 사용하실 수 있습니다.",
                  style: TextStyle(
                    color: Color(0xff9a9a9a),
                    fontSize: 20
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}