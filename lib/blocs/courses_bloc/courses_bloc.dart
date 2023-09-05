import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range/duration_range.dart';
import 'package:online_learning_app/services/firestore_service.dart';
import 'package:online_learning_app/utils/get_uisd_catogories.dart';

part 'courses_event.dart';

part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(const CoursesState()) {
    MyFirestoreService fireStoreService = MyFirestoreService();

    on<ChangeFilterText>((event, emit) async {
      emit(
        state.copyWith(
          filterText: event.newFilterText,
        ),
      );
      add(GetFilteredCourses());
    });

    on<GetFilteredCourses>((event, emit) async {
      // convert list names category to uid of this categories
      List<String> uidsSelectedCategories =
          getUidsCategories(state.filterCategory, state.categoryList);

      List<CourseModel> filteredCoursesList =
          await fireStoreService.getFilteredCoursesList(
        uidsSelectedCategories: uidsSelectedCategories,
        minPrice: state.filterPriceRangeValues.start,
        maxPrice: state.filterPriceRangeValues.end,
        filterDurationItems: state.filterDurationItems,
        filterText: state.filterText,
      );
      // log('*** filteredCoursesList: $filteredCoursesList');
      emit(
        state.copyWith(
          filteredCoursesList: filteredCoursesList,
        ),
      );
    });

    on<ChangePriceFilter>((event, emit) async {
      emit(
        state.copyWith(
          filterPriceRangeValues: RangeValues(
            event.currentRangeValues.start.round().toDouble(),
            event.currentRangeValues.end.round().toDouble(),
          ),
        ),
      );
      add(GetFilteredCourses());
    });

    on<InverseDurationRangeItem>((event, emit) async {
      // print('@@@ InverseDurationRangeItem');
      List<DurationRange> filterDurationItems = [];
      for (DurationRange durationItem in state.filterDurationItems) {
        if (durationItem.min == event.durationRange.min) {
          durationItem = durationItem.copyWith(
            isEnable: !durationItem.isEnable,
            // isEnable: true,
          );
        } else {
          durationItem = durationItem.copyWith(
            // isEnable: !durationItem.isEnable,
            isEnable: false,
          );
        }
        filterDurationItems.add(durationItem);
      }
      emit(
        state.copyWith(
          filterDurationItems: filterDurationItems,
        ),
      );
      add(GetFilteredCourses());
    });

    on<ChangefilterCategory>((event, emit) async {
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
    });

    on<FilterBottomSheetDisable>((event, emit) async {
      emit(
        state.copyWith(
          filterStatus: FilterBottomSheetStatus.disable,
        ),
      );
    });

    on<FilterBottomSheetEnable>((event, emit) async {
      emit(
        state.copyWith(
          filterStatus: FilterBottomSheetStatus.enable,
        ),
      );
    });

    on<GetAllCourses>((event, emit) async {
      List<CourseModel> coursesList =
          await fireStoreService.getAllCoursesList(event.orderBy);
      double maxPricePerCourse = 1;
      for (var course in coursesList) {
        if (course.price != null) {
          if (course.price! > maxPricePerCourse) {
            maxPricePerCourse = course.price!;
          }
        }
      }
      // log('*** coursesList: $coursesList');
      emit(
        state.copyWith(
          coursesList: coursesList,
          maxPricePerCourse: maxPricePerCourse,
          filterPriceRangeValues: RangeValues(0, maxPricePerCourse),
        ),
      );
    });

/*    on<GetAllCoursesSortDuration>((event, emit) async {
      List<CourseModel> filteredCoursesList = await fireStoreService.getAllCoursesListSortDuration();
      // log('*** filteredCoursesList: $filteredCoursesList');
      emit(
        state.copyWith(
          filteredCoursesList: filteredCoursesList,
        ),
      );
    });*/

    on<GetCategories>((event, emit) async {
      log('@@@ GetCategories');
      List<CategoryModel> categoryList = await fireStoreService.getCategories();
      // log('*** categoryList: $categoryList');
      emit(
        state.copyWith(
          categoryList: categoryList,
        ),
      );
    });

    on<CourseBlocInit>((event, emit) async {
      log('@@@ CourseBlocInit');
      add(GetCategories());
      add(GetAllCourses(orderBy: 'name'));
    });
  }
}
