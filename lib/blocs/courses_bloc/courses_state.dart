part of 'courses_bloc.dart';

enum CoursesStateStatus { initial, menu, tab }

@immutable
class CoursesState {
  const CoursesState({
    this.status = CoursesStateStatus.initial,
    this.currentIndex = 0,
    this.coursesList = const [],
    this.categoryList = const [],
  });

  final CoursesStateStatus status;
  final int currentIndex;
  final List<CourseModel> coursesList;
  final List<CategoryModel> categoryList;

  CoursesState copyWith({
    CoursesStateStatus? status,
    int? currentIndex,
    String? route,
    List<CourseModel>? coursesList,
    List<CategoryModel>? categoryList,
  }) {
    return CoursesState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      coursesList: coursesList ?? this.coursesList,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
