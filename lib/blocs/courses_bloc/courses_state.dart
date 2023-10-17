part of 'courses_bloc.dart';

enum FilterBottomSheetStatus { enable, disable }
enum FilterEnabledType { text, price, duration, all}
enum OrderBy { name, duration, created}

@immutable
class CoursesState extends Equatable {
  const CoursesState({
    this.filterStatus = FilterBottomSheetStatus.disable,
    this.currentIndex = 0,
    this.coursesList = const [],
    this.categoryList = const [],
    this.filterCategory = const {},
    this.filterDurationItems = const [
      DurationRangeModel(min: 0, max: 3, isEnable: false),
      DurationRangeModel(min: 3, max: 8, isEnable: false),
      DurationRangeModel(min: 8, max: 14, isEnable: false),
      DurationRangeModel(min: 14, max: 20, isEnable: false),
      DurationRangeModel(min: 20, max: 24, isEnable: false),
      DurationRangeModel(min: 24, max: 30, isEnable: false),
    ],
    this.filterPriceRangeValues = const RangeValues(0.0, 1.0),
    this.filteredCoursesList = const [],
    this.maxPricePerCourse = 1,
    this.filterText = '',
    this.isFilterNavToSearchPage = true,
    this.filterEnabledType = FilterEnabledType.all,
    this.userCoursesList = const [],
    this.favoriteList = const [],

  });

  @override
  List<Object?> get props => [
    filterStatus,
    currentIndex,
    coursesList,
    categoryList,
    filterCategory,
    filterDurationItems,
    filterPriceRangeValues,
    filteredCoursesList,
    maxPricePerCourse,
    filterText,
    isFilterNavToSearchPage,
    filterEnabledType,
    userCoursesList,
    favoriteList,
  ];

  final FilterBottomSheetStatus filterStatus;
  final int currentIndex;
  final List<CourseModel> coursesList;
  final List<CategoryModel> categoryList;
  final Set<String> filterCategory;
  final List<DurationRangeModel> filterDurationItems;
  final RangeValues filterPriceRangeValues;
  final List<CourseModel> filteredCoursesList;
  final double maxPricePerCourse;
  final String filterText;
  final bool isFilterNavToSearchPage;
  final FilterEnabledType filterEnabledType;
  final List<CourseModel> userCoursesList;
  final List<CourseModel> favoriteList;

  CoursesState copyWith({
    FilterBottomSheetStatus? filterStatus,
    int? currentIndex,
    String? route,
    List<CourseModel>? coursesList,
    List<CategoryModel>? categoryList,

    Set<String>? filterCategory,
    List<DurationRangeModel>? filterDurationItems,
    RangeValues? filterPriceRangeValues,
    List<CourseModel>? filteredCoursesList,
    double? maxPricePerCourse,
    String? filterText,
    bool? isFilterNavToSearchPage,
    FilterEnabledType? filterEnabledType,
    List<CourseModel>? userCoursesList,
    List<CourseModel>? favoriteList,
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
      isFilterNavToSearchPage: isFilterNavToSearchPage ?? this.isFilterNavToSearchPage,
      filterEnabledType: filterEnabledType ?? this.filterEnabledType,
      userCoursesList: userCoursesList ?? this.userCoursesList,
      favoriteList: favoriteList ?? this.favoriteList,
    );
  }
}
