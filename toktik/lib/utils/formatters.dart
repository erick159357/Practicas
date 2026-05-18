import 'package:intl/intl.dart';

String formatLikes(int likes) {
  return NumberFormat.compact(locale: Intl.getCurrentLocale()).format(likes);
}

String formatViews(int views) {
  return NumberFormat.compact(locale: Intl.getCurrentLocale()).format(views);
}

String formatDateShort(DateTime date) {
  return DateFormat('d MMM y', Intl.getCurrentLocale()).format(date);
}
