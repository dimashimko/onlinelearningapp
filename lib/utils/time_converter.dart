String durationToString({
  required int second,
}) {
  final int hours = second ~/ 3600;
  final int minutes = second ~/ 60;
  // final int minutes = (second ~/ 60) % 60;
  if (hours > 0) return '$hours hours';
  if (minutes > 0) return '$minutes minutes';
  return '$second second';
}


// CONCAT(
// FLOOR(item.duration / 3600).toString().padStart(2, "0"),
// ":",
// FLOOR((item.duration / 60) % 60).toString().padStart(2, "0"),
// ":",
// ROUND(item.duration % 60).toString().padStart(2, "0")
// )