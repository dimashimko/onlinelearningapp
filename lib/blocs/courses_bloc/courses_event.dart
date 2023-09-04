part of 'courses_bloc.dart';

@immutable
abstract class CoursesEvent {}

class ChangePriceFilter extends CoursesEvent {
  ChangePriceFilter({
    required this.currentRangeValues,
  });

  final RangeValues currentRangeValues;
}

class InverseDurationRangeItem extends CoursesEvent {
  InverseDurationRangeItem({
    required this.durationRange,
  });

  final DurationRange durationRange;
}

class ChangeCategoryFilter extends CoursesEvent {
  ChangeCategoryFilter({
    this.add,
    this.remove,
    this.clear,
  });

  final String? add;
  final String? remove;
  final bool? clear;
}

class FilterBottomSheetDisable extends CoursesEvent {}

class FilterBottomSheetEnable extends CoursesEvent {}

class GetFilteredCourses extends CoursesEvent {}

class GetAllCourses extends CoursesEvent {
  GetAllCourses({
    required this.orderBy,
  });

  final String orderBy;
}

class GetAllCoursesSortDuration extends CoursesEvent {}

class GetCategories extends CoursesEvent {}

class CourseBlocInit extends CoursesEvent {}

/*
class GetAllCourses extends CoursesEvent {
  GetAllCourses({
    required this.menuIndex,
  });

  final int menuIndex;
}
*/
