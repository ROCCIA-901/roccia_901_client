import 'package:flutter/material.dart';

import '../../constants/size_config.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  SizeConfig _sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    _sizeConfig = SizeConfig();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: _sizeConfig.safeBlockHorizontal * 7,
                top: _sizeConfig.safeBlockVertical * 3,
              ),
              child: Text(
                '대회',
                style: TextStyle(
                  fontSize: _sizeConfig.safeBlockHorizontal * 5.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: _sizeConfig.safeBlockVertical * 70,
              alignment: Alignment.center,
              child: Text(
                "대회 기간에 사용하실 수 있습니다.",
                style: TextStyle(
                  color: Color(0xff9a9a9a),
                  fontSize: _sizeConfig.safeBlockHorizontal * 4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
