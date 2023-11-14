import 'dart:io';

import 'package:flutter/widgets.dart';

late double x, y, f;

void initialiseResponsiveUI(BuildContext context) {
  x = MediaQuery.of(context).size.width / 376;
  y = MediaQuery.of(context).size.height / 764;
  f = (x + y) / 2;

  if (Platform.isIOS) {
    f = f * 0.9;
  }
}
