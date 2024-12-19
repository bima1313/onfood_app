import 'package:flutter/material.dart';

/// Function `getColor` for changing a color if the order is [`null`] or [`not`]
Color? getColor({
  required Map<String, dynamic> getMap,
  required String key,
  required int values,
}) {
  if (values == 0) {
    return const Color.fromARGB(255, 255, 201, 111);
  } else if (!getMap.containsKey(key)) {
    return const Color.fromARGB(255, 255, 201, 111);
  } else if ((getMap.containsKey(key)) & (getMap[key] == 0)) {
    return const Color.fromARGB(255, 255, 201, 111);
  } else {
    return const Color.fromARGB(255, 255, 166, 47);
  }
}
