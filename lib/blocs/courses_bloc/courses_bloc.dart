import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range/duration_range.dart';
import 'package:online_learning_app/services/firestore_service.dart';

part 'courses_event.dart';

part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(const CoursesState()) {
    MyFirestoreService fireStoreService = MyFirestoreService();


    on<GetFilteredCourses>((event, emit) async {
      List<CourseModel> filteredCoursesList =
      await fireStoreService.getFilteredCoursesList();
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
          priceFilterRangeValues: event.currentRangeValues,
        ),
      );
    });

    on<InverseDurationRangeItem>((event, emit) async {
      List<DurationRange> durationItems = [];
      for (DurationRange durationItem in state.durationItems) {
        if (durationItem.min == event.durationRange.min) {
          durationItem = durationItem.copyWith(
            isEnable: !durationItem.isEnable,
          );
        }
        durationItems.add(durationItem);
      }
      emit(
        state.copyWith(
          durationItems: durationItems,
        ),
      );
    });

    on<ChangeCategoryFilter>((event, emit) async {
      Set<String> categoryFilter = {...state.categoryFilter};
      if (event.add != null) categoryFilter.add(event.add!);
      if (event.remove != null) categoryFilter.remove(event.remove!);
      if (event.clear != null && event.clear == true) categoryFilter = {};
      emit(
        state.copyWith(
          categoryFilter: categoryFilter,
        ),
      );
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
      // log('*** coursesList: $coursesList');
      emit(
        state.copyWith(
          coursesList: coursesList,
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
