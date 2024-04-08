import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
//     Future.delayed(
//       Duration(seconds: 3),
//       () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TmpAllScreenListScreen(),
//           ),
//         );
//       },
//     );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/roccia_full_logo.svg',
          width: SizeConfig.safeBlockHorizontal * 55,
        ),
      ),
    );
  }
}
