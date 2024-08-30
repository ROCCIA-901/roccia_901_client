import 'package:flutter/material.dart';
import 'package:untitled/constants/size_config.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        constraints: BoxConstraints.tight(Size.square(AppSize.of(context).safeBlockHorizontal * 10)),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: AppSize.of(context).safeBlockHorizontal * 0.8),
        margin: EdgeInsets.zero,
        child: FittedBox(
          fit: BoxFit.contain,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: AppSize.of(context).safeBlockHorizontal * 5,
            color: Colors.black,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    );
  }
}
