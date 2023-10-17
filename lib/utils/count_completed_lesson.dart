import 'package:online_learning_app/models/progress/progress_model.dart';

int countCompletedLesson({CourseProgressModel? userProgress}) {
  int completedLesson = 0;
  if (userProgress != null) {
    if (userProgress.lessonsProgress != null) {
      for (List<bool> lessonProgress in userProgress.lessonsProgress!.values) {
        if (allTrue(lessonProgress)) completedLesson++;
      }
    }
  }
  return completedLesson;
}

bool allTrue(List<bool> boolList) {
  for (bool element in boolList) {
    if (!element) {
      return false;
    }
  }
  return true;
}
