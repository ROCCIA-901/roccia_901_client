import 'package:flutter/material.dart';

class AppCommonTextButton extends StatelessWidget {
  // 버튼 안 텍스트
  final Text text;
  // 버튼 색
  final Color backgroundColor;
  // 버튼의 모서리 원주율
  final double cornerRadius;
  // 버튼의 너비
  final double width;
  // 버튼의 높이
  final double height;
  // 버튼의 크기 비율, width와 height 중
  // 버튼이 눌렸을 때 행동 callback
  final void Function() onPressed;

  const AppCommonTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.cornerRadius,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: text.style?.color,
          textStyle: text.style,
        ),
        onPressed: onPressed,
        child: Text(text.data ?? ''),
      ),
    );
  }
}
