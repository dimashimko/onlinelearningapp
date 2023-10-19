import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range_model/duration_range_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/services/firestore_course_service.dart';
import 'package:online_learning_app/utils/get_uisd_catogories.dart';

part 'courses_event.dart';

part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final MyFirestoreCourseService fireStoreService = MyFirestoreCourseService();

  CoursesBloc() : super(const CoursesState()) {
    on<FilterUserCourses>(_filterUserCourses);
    on<ChangeEnabledFilter>(_changeEnabledFilter);
    on<ClearFilters>(_clearFilters);
    on<GetFilteredCourses>(_getFilteredCourses);
    on<ChangeFilterText>(_changeFilterText);
    on<ChangePriceFilter>(_changePriceFilter);
    on<InverseDurationRangeItem>(_inverseDurationRangeItem);
    on<ChangeFilterCategory>(_changeFilterCategory);
    on<FilterBottomSheetDisable>(_filterBottomSheetDisable);
    on<FilterBottomSheetEnable>(_filterBottomSheetEnable);
    on<GetAllCourses>(_getAllCourses);
    on<GetCategories>(_getCategories);
    on<CourseBlocInit>(_courseBlocInit);
  }

  // Add method implementations here

  void _filterUserCourses(
    FilterUserCourses event,
    Emitter<CoursesState> emit,
  ) async {
    {
      Map<String, CourseProgressModel> userProgress = event.userProgress ?? {};

      List<CourseModel> userCoursesList = state.coursesList.where((course) {
        CourseProgressModel? progress = userProgress[course.uid];
        if (progress != null) {
          if ((progress.favorites ?? false) || (progress.bought ?? false)) {
            return true;
          }
        }
        return false;
      }).toList();

      List<CourseModel> favoriteList = state.coursesList.where((course) {
        CourseProgressModel? progress = userProgress[course.uid];
        if (progress != null) {
          if ((progress.favorites ?? false)) {
            return true;
          }
        }
        return false;
      }).toList();

      emit(
        state.copyWith(
          userCoursesList: userCoursesList,
          favoriteList: favoriteList,
        ),
      );
    }
  }

  void _changeEnabledFilter(
    ChangeEnabledFilter event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      state.copyWith(
        filterEnabledType: event.newFilterEnabledType,
      ),
    );
    add(GetFilteredCourses());
  }

  void _clearFilters(
    ClearFilters event,
    Emitter<CoursesState> emit,
  ) async {
    List<DurationRangeModel> newFilterDurationItems = [];
    for (DurationRangeModel durationItem in state.filterDurationItems) {
      newFilterDurationItems.add(durationItem.copyWith(isEnable: false));
    }

    emit(
      state.copyWith(
        filterCategory: {},
        filterDurationItems: newFilterDurationItems,
        filterPriceRangeValues: RangeValues(0.0, state.maxPricePerCourse),
        filterText: '',
        filterEnabledType: FilterEnabledType.all,
      ),
    );
    add(GetFilteredCourses());
  }

  void _getFilteredCourses(
    GetFilteredCourses event,
    Emitter<CoursesState> emit,
  ) async {
    List<String> uidsSelectedCategories =
        getUidsCategories(state.filterCategory, state.categoryList);

    List<CourseModel> filteredCoursesList =
        await fireStoreService.getFilteredCoursesList(
      uidsSelectedCategories: uidsSelectedCategories,
      minPrice: state.filterPriceRangeValues.start,
      maxPrice: state.filterPriceRangeValues.end,
      filterDurationItems: state.filterDurationItems,
      searchKey: state.filterText,
      filterEnabledType: state.filterEnabledType,
    );

    emit(
      state.copyWith(
        filteredCoursesList: filteredCoursesList,
      ),
    );
  }

  void _changeFilterText(
    ChangeFilterText event,
    Emitter<CoursesState> emit,
  ) async {
    if (state.filterText != event.newFilterText) {
      FilterEnabledType newFilterEnabledType = FilterEnabledType.text;
      if (event.newFilterText.isEmpty) {
        newFilterEnabledType = FilterEnabledType.all;
      }
      emit(
        state.copyWith(
          filterText: event.newFilterText,
          filterEnabledType: newFilterEnabledType,
        ),
      );
      add(GetFilteredCourses());
    }
  }

  void _changePriceFilter(
    ChangePriceFilter event,
    Emitter<CoursesState> emit,
  ) async {
    FilterEnabledType newFilterEnabledType = FilterEnabledType.price;
    if (state.filterPriceRangeValues.start == 0.0 &&
        state.filterPriceRangeValues.end == state.maxPricePerCourse) {
      newFilterEnabledType = FilterEnabledType.all;
    }
    emit(
      state.copyWith(
        filterPriceRangeValues: RangeValues(
          event.currentRangeValues.start.round().toDouble(),
          event.currentRangeValues.end.round().toDouble(),
        ),
        filterEnabledType: newFilterEnabledType,
      ),
    );
    add(GetFilteredCourses());
  }

  void _inverseDurationRangeItem(
    InverseDurationRangeItem event,
    Emitter<CoursesState> emit,
  ) async {
    FilterEnabledType newFilterEnabledType = FilterEnabledType.duration;

    List<DurationRangeModel> filterDurationItems = [];
    for (DurationRangeModel durationItem in state.filterDurationItems) {
      if (durationItem.min == event.durationRange.min) {
        durationItem = durationItem.copyWith(
          isEnable: !durationItem.isEnable,
        );
        if (!durationItem.isEnable) {
          newFilterEnabledType = FilterEnabledType.all;
        }
      } else {
        durationItem = durationItem.copyWith(
          isEnable: false,
        );
      }
      filterDurationItems.add(durationItem);
    }
    emit(
      state.copyWith(
        filterDurationItems: filterDurationItems,
        filterEnabledType: newFilterEnabledType,
      ),
    );
    add(GetFilteredCourses());
  }

  void _changeFilterCategory(
    ChangeFilterCategory event,
    Emitter<CoursesState> emit,
  ) async {
    Set<String> filterCategory = {...state.filterCategory};
    if (event.add != null) filterCategory.add(event.add!);
    if (event.remove != null) filterCategory.remove(event.remove!);
    if (event.clear != null && event.clear == true) filterCategory = {};

    emit(
      state.copyWith(
        filterCategory: filterCategory,
      ),
    );
    add(GetFilteredCourses());
  }

  void _filterBottomSheetDisable(
    FilterBottomSheetDisable event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      state.copyWith(
        filterStatus: FilterBottomSheetStatus.disable,
      ),
    );
  }

  void _filterBottomSheetEnable(
    FilterBottomSheetEnable event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      state.copyWith(
          filterStatus: FilterBottomSheetStatus.enable,
          isFilterNavToSearchPage: event.isFilterNavToSearchPage),
    );
  }

  void _getAllCourses(
    GetAllCourses event,
    Emitter<CoursesState> emit,
  ) async {
    List<CourseModel> coursesList =
        await fireStoreService.getAllCoursesList(event.orderBy);
    if (event.orderBy == OrderBy.created.name) {
      coursesList = coursesList.reversed.toList();
    }
    double maxPricePerCourse = 1;
    for (var course in coursesList) {
      if (course.price != null) {
        if (course.price! > maxPricePerCourse) {
          maxPricePerCourse = course.price!;
        }
      }
    }

    emit(
      state.copyWith(
        coursesList: coursesList,
        maxPricePerCourse: maxPricePerCourse,
        filterPriceRangeValues: RangeValues(0, maxPricePerCourse),
      ),
    );
  }

  void _getCategories(
    GetCategories event,
    Emitter<CoursesState> emit,
  ) async {
    List<CategoryModel> categoryList = await fireStoreService.getCategories();

    emit(
      state.copyWith(
        categoryList: categoryList,
      ),
    );
  }

  void _courseBlocInit(
    CourseBlocInit event,
    Emitter<CoursesState> emit,
  ) async {
    add(GetCategories());
    add(GetAllCourses(orderBy: OrderBy.name.name));
  }
}

// class CoursesBloc2 extends Bloc<CoursesEvent, CoursesState> {
//   CoursesBloc2() : super(const CoursesState()) {
//     MyFirestoreCourseService fireStoreService = MyFirestoreCourseService();
//
//     on<FilterUserCourses>((event, emit) async {
//       Map<String, CourseProgressModel> userProgress = event.userProgress ?? {};
//
//       List<CourseModel> userCoursesList = state.coursesList.where((course) {
//         CourseProgressModel? progress = userProgress[course.uid];
//         if (progress != null) {
//           if ((progress.favorites ?? false) || (progress.bought ?? false)) {
//             return true;
//           }
//         }
//         return false;
//       }).toList();
//
//       List<CourseModel> favoriteList = state.coursesList.where((course) {
//         CourseProgressModel? progress = userProgress[course.uid];
//         if (progress != null) {
//           if ((progress.favorites ?? false)) {
//             return true;
//           }
//         }
//         return false;
//       }).toList();
//
//       emit(
//         state.copyWith(
//           userCoursesList: userCoursesList,
//           favoriteList: favoriteList,
//         ),
//       );
//     });
//
//     on<ChangeEnabledFilter>((event, emit) async {
//       emit(
//         state.copyWith(
//           filterEnabledType: event.newFilterEnabledType,
//         ),
//       );
//       add(GetFilteredCourses());
//     });
//
//     on<ClearFilters>((event, emit) async {
//       List<DurationRangeModel> newFilterDurationItems = [];
//       for (DurationRangeModel durationItem in state.filterDurationItems) {
//         newFilterDurationItems.add(durationItem.copyWith(isEnable: false));
//       }
//
//       emit(
//         state.copyWith(
//           filterCategory: {},
//           filterDurationItems: newFilterDurationItems,
//           filterPriceRangeValues: RangeValues(0.0, state.maxPricePerCourse),
//           filterText: '',
//           filterEnabledType: FilterEnabledType.all,
//         ),
//       );
//       add(GetFilteredCourses());
//     });
//
//     on<GetFilteredCourses>((event, emit) async {
//       List<String> uidsSelectedCategories =
//           getUidsCategories(state.filterCategory, state.categoryList);
//
//       List<CourseModel> filteredCoursesList =
//           await fireStoreService.getFilteredCoursesList(
//         uidsSelectedCategories: uidsSelectedCategories,
//         minPrice: state.filterPriceRangeValues.start,
//         maxPrice: state.filterPriceRangeValues.end,
//         filterDurationItems: state.filterDurationItems,
//         searchKey: state.filterText,
//         filterEnabledType: state.filterEnabledType,
//       );
//
//       emit(
//         state.copyWith(
//           filteredCoursesList: filteredCoursesList,
//         ),
//       );
//     });
//
//     on<ChangeFilterText>((event, emit) async {
//       if (state.filterText != event.newFilterText) {
//         FilterEnabledType newFilterEnabledType = FilterEnabledType.text;
//         if (event.newFilterText.isEmpty) {
//           newFilterEnabledType = FilterEnabledType.all;
//         }
//         emit(
//           state.copyWith(
//             filterText: event.newFilterText,
//             filterEnabledType: newFilterEnabledType,
//           ),
//         );
//         add(GetFilteredCourses());
//       }
//     });
//
//     on<ChangePriceFilter>((event, emit) async {
//       FilterEnabledType newFilterEnabledType = FilterEnabledType.price;
//       if (state.filterPriceRangeValues.start == 0.0 &&
//           state.filterPriceRangeValues.end == state.maxPricePerCourse) {
//         newFilterEnabledType = FilterEnabledType.all;
//       }
//       emit(
//         state.copyWith(
//           filterPriceRangeValues: RangeValues(
//             event.currentRangeValues.start.round().toDouble(),
//             event.currentRangeValues.end.round().toDouble(),
//           ),
//           filterEnabledType: newFilterEnabledType,
//         ),
//       );
//       add(GetFilteredCourses());
//     });
//
//     on<InverseDurationRangeItem>((event, emit) async {
//       FilterEnabledType newFilterEnabledType = FilterEnabledType.duration;
//
//       List<DurationRangeModel> filterDurationItems = [];
//       for (DurationRangeModel durationItem in state.filterDurationItems) {
//         if (durationItem.min == event.durationRange.min) {
//           durationItem = durationItem.copyWith(
//             isEnable: !durationItem.isEnable,
//           );
//           if (!durationItem.isEnable) {
//             newFilterEnabledType = FilterEnabledType.all;
//           }
//         } else {
//           durationItem = durationItem.copyWith(
//             isEnable: false,
//           );
//         }
//         filterDurationItems.add(durationItem);
//       }
//       emit(
//         state.copyWith(
//           filterDurationItems: filterDurationItems,
//           filterEnabledType: newFilterEnabledType,
//         ),
//       );
//       add(GetFilteredCourses());
//     });
//
//     on<ChangeFilterCategory>((event, emit) async {
//       Set<String> filterCategory = {...state.filterCategory};
//       if (event.add != null) filterCategory.add(event.add!);
//       if (event.remove != null) filterCategory.remove(event.remove!);
//       if (event.clear != null && event.clear == true) filterCategory = {};
//
//       emit(
//         state.copyWith(
//           filterCategory: filterCategory,
//         ),
//       );
//       add(GetFilteredCourses());
//     });
//
//     on<FilterBottomSheetDisable>((event, emit) async {
//       emit(
//         state.copyWith(
//           filterStatus: FilterBottomSheetStatus.disable,
//         ),
//       );
//     });
//
//     on<FilterBottomSheetEnable>((event, emit) async {
//       emit(
//         state.copyWith(
//             filterStatus: FilterBottomSheetStatus.enable,
//             isFilterNavToSearchPage: event.isFilterNavToSearchPage),
//       );
//     });
//
//     on<GetAllCourses>((event, emit) async {
//       List<CourseModel> coursesList =
//           await fireStoreService.getAllCoursesList(event.orderBy);
//       if (event.orderBy == OrderBy.created.name) {
//         coursesList = coursesList.reversed.toList();
//       }
//       double maxPricePerCourse = 1;
//       for (var course in coursesList) {
//         if (course.price != null) {
//           if (course.price! > maxPricePerCourse) {
//             maxPricePerCourse = course.price!;
//           }
//         }
//       }
//
//       emit(
//         state.copyWith(
//           coursesList: coursesList,
//           maxPricePerCourse: maxPricePerCourse,
//           filterPriceRangeValues: RangeValues(0, maxPricePerCourse),
//         ),
//       );
//     });
//
//     on<GetCategories>((event, emit) async {
//       List<CategoryModel> categoryList = await fireStoreService.getCategories();
//
//       emit(
//         state.copyWith(
//           categoryList: categoryList,
//         ),
//       );
//     });
//
//     on<CourseBlocInit>((event, emit) async {
//       add(GetCategories());
//       add(GetAllCourses(orderBy: OrderBy.name.name));
//     });
//   }
// }
