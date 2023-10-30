import 'package:intl/intl.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';

extension ListX on List<CategoryModel> {
  List<String>  getUidsCategories(Set<String> categories,) {
    List<String> result = [];
    for (CategoryModel category in this) {
      if (categories.contains(category.name)) {
        if (category.uid != null) {
          result.add(category.uid!);
        }
      }
    }
    return result;
  }
}

extension CourseProgressModelX on CourseProgressModel {
  int countCompletedLesson() {
    int completedLesson = 0;
    if (lessonsProgress != null) {
      for (List<bool> lessonProgress in lessonsProgress!.values) {
        if (allTrue(lessonProgress)) completedLesson++;
      }
    }
      return completedLesson;
  }
}

bool allTrue(List<bool> boolList) {
  for (bool element in boolList) {
    if (!element) {
      return false;
    }
  }
  return true;
}

extension DataTimeConverter on DateTime {
  String toRelativeTime() {
    Duration difference = DateTime.now().difference(this);
    if (difference.inDays > 0) {
      return DateFormat.yMMMd().format(this);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

extension DurationX on Duration {
  String formatToHour() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = inHours.toString();
    final String minutes = twoDigits(inMinutes.remainder(60));
    return '${hours}h ${minutes}min';
  }

  String formatToMinutes() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = inMinutes.toString();
    final String seconds = twoDigits(inSeconds.remainder(60));
    return '$minutes:${seconds}mins';
  }
}

extension IntX on int {
  String toTimeDurationString() {
    final int hours = this ~/ 3600;
    final int minutes = this ~/ 60;

    if (hours > 0) return '$hours hours';
    if (minutes > 0) return '$minutes minutes';
    return '$this second';
  }
}
