part of 'courses_bloc.dart';

enum FilterBottomSheetStatus { enable, disable }

@immutable
class CoursesState {
  const CoursesState({
    this.filterStatus = FilterBottomSheetStatus.disable,
    this.currentIndex = 0,
    this.coursesList = const [],
    this.categoryList = const [],
    this.filterCategory = const {},
    this.filterDurationItems = const [
      DurationRange(min: 3, max: 8, isEnable: false),
      DurationRange(min: 8, max: 14, isEnable: false),
      DurationRange(min: 14, max: 20, isEnable: false),
      DurationRange(min: 20, max: 24, isEnable: false),
      DurationRange(min: 24, max: 30, isEnable: false),
    ],
    this.filterPriceRangeValues = const RangeValues(0.0, 1.0),
    this.filteredCoursesList = const [],
    this.maxPricePerCourse = 1,
    this.filterText = '',

  });

  final FilterBottomSheetStatus filterStatus;
  final int currentIndex;
  final List<CourseModel> coursesList;
  final List<CategoryModel> categoryList;
  final Set<String> filterCategory;
  final List<DurationRange> filterDurationItems;
  final RangeValues filterPriceRangeValues;
  final List<CourseModel> filteredCoursesList;
  final double maxPricePerCourse;
  final String filterText;

  CoursesState copyWith({
    FilterBottomSheetStatus? filterStatus,
    int? currentIndex,
    String? route,
    List<CourseModel>? coursesList,
    List<CategoryModel>? categoryList,
    // filter
    Set<String>? filterCategory,
    List<DurationRange>? filterDurationItems,
    RangeValues? filterPriceRangeValues,
    List<CourseModel>? filteredCoursesList,
    double? maxPricePerCourse,
    String? filterText,
  }) {
    return CoursesState(
      filterStatus: filterStatus ?? this.filterStatus,
      currentIndex: currentIndex ?? this.currentIndex,
      coursesList: coursesList ?? this.coursesList,
      categoryList: categoryList ?? this.categoryList,
      filterCategory: filterCategory ?? this.filterCategory,
      filterDurationItems: filterDurationItems ?? this.filterDurationItems,
      filterPriceRangeValues: filterPriceRangeValues ?? this.filterPriceRangeValues,
      filteredCoursesList: filteredCoursesList ?? this.filteredCoursesList,
      maxPricePerCourse: maxPricePerCourse ?? this.maxPricePerCourse,
      filterText: filterText ?? this.filterText,
    );
  }
}
