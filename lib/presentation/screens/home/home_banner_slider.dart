import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path_package;

import '../../../constants/app_constants.dart';
import '../../../constants/size_config.dart';

class HomeBannerSlider extends StatelessWidget {
  const HomeBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1,
        height: AppSize.of(context).safeBlockHorizontal * 23,
      ),
      items: AppConstants.banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () async => await launchUrl(Uri.parse(banner.url)),
              child: path_package.extension(banner.asset) == '.svg'
                  ? SvgPicture.asset(
                      banner.asset,
                      width: AppSize.of(context).safeBlockHorizontal * 100,
                    )
                  : Image.asset(
                      banner.asset,
                      width: AppSize.of(context).safeBlockHorizontal * 100,
                    ),
            );
          },
        );
      }).toList(),
    );
  }
}
