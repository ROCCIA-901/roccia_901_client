import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyRecordTab extends StatelessWidget {
  const MyRecordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("내 기록"),
          height: 550,
          alignment: Alignment.center,
        ),
        Container(
          child: InkWell(
            child: SvgPicture.asset(
              'assets/icons/buttons/record_myrecord.svg',
              height: 50,
            ),
          ),
        )
      ],
    );
  }
}
