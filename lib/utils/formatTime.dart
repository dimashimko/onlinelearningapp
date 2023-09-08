String formatTimeToHour(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String hours = duration.inHours.toString();
  final String minutes = twoDigits(duration.inMinutes.remainder(60));
  return '${hours}h ${minutes}min';
}


String formatTimeToMinutes(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String minutes = duration.inMinutes.toString();
  final String seconds = twoDigits(duration.inSeconds.remainder(60));
  return '${minutes}:${seconds  }mins';
}
