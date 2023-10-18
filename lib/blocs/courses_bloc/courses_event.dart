part of 'courses_bloc.dart';

@immutable
abstract class CoursesEvent {}

class FilterUserCourses extends CoursesEvent {
  FilterUserCourses({
    required this.userProgress,
  });

  final Map<String, CourseProgressModel>? userProgress;
}

class ChangeEnabledFilter extends CoursesEvent {
  ChangeEnabledFilter({
    required this.newFilterEnabledType,
  });

  final FilterEnabledType newFilterEnabledType;
}

class ClearFilters extends CoursesEvent {}

class ChangeFilterText extends CoursesEvent {
  ChangeFilterText({
    required this.newFilterText,
  });

  final String newFilterText;
}

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

  final DurationRangeModel durationRange;
}

class ChangeFilterCategory extends CoursesEvent {
  ChangeFilterCategory({
    this.add,
    this.remove,
    this.clear,
  });

  final String? add;
  final String? remove;
  final bool? clear;
}

class FilterBottomSheetDisable extends CoursesEvent {}

class FilterBottomSheetEnable extends CoursesEvent {
  FilterBottomSheetEnable({
    required this.isFilterNavToSearchPage,
  });

  final bool isFilterNavToSearchPage;
}

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
