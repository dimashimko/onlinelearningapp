part of 'courses_bloc.dart';

enum FilterBottomSheetStatus { enable, disable }

@immutable
class CoursesState {
  const CoursesState({
    this.filterStatus = FilterBottomSheetStatus.disable,
    this.currentIndex = 0,
    this.coursesList = const [],
    this.categoryList = const [],
    this.categoryFilter = const {},
    this.durationItems = const [
      DurationRange(min: 3, max: 8, isEnable: false),
      DurationRange(min: 8, max: 14, isEnable: false),
      DurationRange(min: 14, max: 20, isEnable: false),
      DurationRange(min: 20, max: 24, isEnable: false),
      DurationRange(min: 24, max: 30, isEnable: false),
    ],
  });

  final FilterBottomSheetStatus filterStatus;
  final int currentIndex;
  final List<CourseModel> coursesList;
  final List<CategoryModel> categoryList;
  final Set<String> categoryFilter;
  final List<DurationRange> durationItems;

  CoursesState copyWith({
    FilterBottomSheetStatus? filterStatus,
    int? currentIndex,
    String? route,
    List<CourseModel>? coursesList,
    List<CategoryModel>? categoryList,
    Set<String>? categoryFilter,
    List<DurationRange>? durationItems,
  }) {
    return CoursesState(
      filterStatus: filterStatus ?? this.filterStatus,
      currentIndex: currentIndex ?? this.currentIndex,
      coursesList: coursesList ?? this.coursesList,
      categoryList: categoryList ?? this.categoryList,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      durationItems: durationItems ?? this.durationItems,
    );
  }
}
