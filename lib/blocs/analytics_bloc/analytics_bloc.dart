import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(const AnalyticsState()) {

    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;



    on<OnCourseSelectedEvent>(
      (event, emit) async {

        await analytics.logEvent(
          name: 'course_selected',
          parameters: <String, dynamic>{
            'uid': event.currentCourse?.uid,
            'name': event.currentCourse?.name,
            'author': event.currentCourse?.author,
            'category': event.currentCourse?.category,
          },
        );
      },
    );

    on<OnBottomBarEvent>(
      (event, emit) async {


        await analytics.logEvent(
          name: 'bottom_bar_event',
          parameters: <String, dynamic>{
            'bottomBarIndex': event.routeName,
          },
        );
      },
    );

    on<OnTestLogEvent>(
      (event, emit) async {

        DateTime dateTime = DateTime.now();
        String dateTimeNow = dateTime.toString();
        String name = 'platformName';
        if (Platform.isAndroid) {
          name = 'android_dateTimeNow';
        } else if (Platform.isIOS) {
          name = 'iOS_dateTimeNow';
        }

        await analytics.logEvent(
          name: name,
          parameters: <String, dynamic>{
            'dateTime': dateTimeNow,
          },
        );
      },
    );

    on<OnOpenMyCoursesPageEvent>(
      (event, emit) async {
        await analytics.logEvent(
          name: 'on_open_my_course_page',
        );
      },
    );

  }
}
