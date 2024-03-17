import 'package:flutter/material.dart';

import '../widgets/loader_dialog.dart';

class DialogHelper {
  static void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LoaderDialog(),
    );
  }
}
