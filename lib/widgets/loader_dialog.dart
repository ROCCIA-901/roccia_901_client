import 'package:flutter/material.dart';

import '../constants/size_config.dart';

class LoaderDialog extends StatelessWidget {
  const LoaderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        width: SizeConfig.safeBlockHorizontal * 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
  }
}
