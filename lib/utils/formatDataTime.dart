import 'package:intl/intl.dart';

String formatDurationToHour(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String hours = duration.inHours.toString();
  final String minutes = twoDigits(duration.inMinutes.remainder(60));
  return '${hours}h ${minutes}min';
}

String formatDurationToMinutes(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String minutes = duration.inMinutes.toString();
  final String seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:${seconds}mins';
}

String formatSecondsToTimeDuration({
  required int second,
}) {
  final int hours = second ~/ 3600;
  final int minutes = second ~/ 60;

  if (hours > 0) return '$hours hours';
  if (minutes > 0) return '$minutes minutes';
  return '$second second';
}

String formatRelativeTime(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return DateFormat.yMMMd().format(dateTime);
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
