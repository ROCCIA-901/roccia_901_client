import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/size_config.dart';
import 'app_tag_box.dart';

class AppTags extends StatelessWidget {
  final double maxHeight;
  final List<String> tags;

  const AppTags({
    super.key,
    required this.maxHeight,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags
          .map(
            (tag) => Container(
              margin: EdgeInsets.only(right: maxHeight * 0.2),
              child: AppTagBox(
                height: maxHeight,
                strokeColor: Color(0xFFE0E0E0),
                backgroundColor: Colors.white,
                child: Text(
                  tag,
                  style: GoogleFonts.roboto(
                    fontSize: AppSize.of(context).font.content * 0.75,
                    color: Color(0xFF7B7B7B),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
