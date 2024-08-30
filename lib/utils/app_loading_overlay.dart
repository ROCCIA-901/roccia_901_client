import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/size_config.dart';

class AppLoadingOverlay {
  OverlayEntry? _overlayEntry;

  AppLoadingOverlay._();

  static final AppLoadingOverlay _instance = AppLoadingOverlay._();

  static void show(BuildContext context) {
    if (_instance._overlayEntry != null) {
      return;
    }
    _instance._overlayEntry = _instance._buildOverlayEntry(context);
    Overlay.of(context).insert(_instance._overlayEntry!);
  }

  static void hide() {
    _instance._overlayEntry?.remove();
    _instance._overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: LoadingAnimationWidget.inkDrop(
              color: AppColors.primary,
              size: AppSize.of(context).safeBlockHorizontal * 15,
            ),
          ),
        ],
      ),
    );
  }
}
