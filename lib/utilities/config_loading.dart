import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// configuration styles of `EasyLoading`
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..backgroundColor = Colors.white
    ..indicatorColor = const Color.fromARGB(255, 255, 166, 47)
    ..textColor = Colors.black
    ..userInteractions = false
    ..successWidget = const Icon(
      Icons.check,
      color: Colors.green,
      size: 45.0,
    )
    ..dismissOnTap = false;
}
