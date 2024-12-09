// function getColor for changing a color if the order is null and the order is not
import 'package:flutter/material.dart';

WidgetStateProperty<Color?> getColor(Map getMap, String key, int values) {
  if (values == 0) {
    return WidgetStateProperty.all(const Color.fromARGB(255, 255, 201, 111));
  } else if (!getMap.containsKey(key)) {
    return WidgetStateProperty.all(const Color.fromARGB(255, 255, 201, 111));
  } else if ((getMap.containsKey(key)) & (getMap[key] == 0)) {
    return WidgetStateProperty.all(const Color.fromARGB(255, 255, 201, 111));
  } else {
    return WidgetStateProperty.all(const Color.fromARGB(255, 255, 166, 47));
  }
}
