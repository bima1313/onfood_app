import 'package:intl/intl.dart';

/// For casting the `DateTime` into locale `ID {Indonesian}`
String castToID({required DateTime dateTime}) {
  final date = DateFormat.yMMMMd('ID').format(dateTime);
  final time = DateFormat.Hm().format(dateTime);
  return '$date, $time';
}
