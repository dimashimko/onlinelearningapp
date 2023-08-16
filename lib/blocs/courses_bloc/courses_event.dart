part of 'courses_bloc.dart';

@immutable
abstract class CoursesEvent {}

/*class GetAllCourses extends CoursesEvent {
  GetAllCourses();
}*/

class GetAllCourses extends CoursesEvent {
  GetAllCourses({
    required this.orderBy,
  });

  final String orderBy;
}

class GetAllCoursesSortDuration extends CoursesEvent {
  GetAllCoursesSortDuration();
}

class GetCategories extends CoursesEvent {
  GetCategories();
}

class CourseBlocInit extends CoursesEvent {
  CourseBlocInit();
}

/*
class GetAllCourses extends CoursesEvent {
  GetAllCourses({
    required this.menuIndex,
  });

  final int menuIndex;
}
*/

