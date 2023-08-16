import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/services/firestore_service.dart';

part 'courses_event.dart';

part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(const CoursesState()) {
    MyFirestoreService fireStoreService = MyFirestoreService();

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
      List<CourseModel> coursesList = await fireStoreService.getAllCoursesListSortDuration();
      // log('*** coursesList: $coursesList');
      emit(
        state.copyWith(
          coursesList: coursesList,
        ),
      );
    });*/

    on<GetCategories>((event, emit) async {
      log('@@@ GetCategories');
      List<CategoryModel> categoryList =
          await fireStoreService.getCategories();
      log('*** categoryList: $categoryList');
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
