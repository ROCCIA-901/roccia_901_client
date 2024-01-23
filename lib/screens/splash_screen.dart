import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/widgets/bordered_text.dart';

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/roccia_logo.svg',
                width: 60,
              ),
              SizedBox(height: 14),
              BorderedText(
                text: 'ROCCIA 901',
                textStyle: GoogleFonts.archivoBlack(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                textColor: Colors.white,
                strokeColor: Color(0xFFCAE4C1),
                strokeWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
