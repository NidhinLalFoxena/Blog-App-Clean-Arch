import 'package:intl/intl.dart';

String formateDateBydMMMYYYY(DateTime date) {
  return DateFormat("d MMM yyyy").format(date);
}
