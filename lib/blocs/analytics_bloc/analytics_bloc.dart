import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  AnalyticsBloc() : super(const AnalyticsState()) {
    on<OnOpenMyCoursesPageEvent>(_onOpenMyCoursesPageEvent);
    on<OnTestLogEvent>(_onTestLogEvent);
    on<OnCourseSelectedEvent>(_onCourseSelectedEvent);
    on<OnBottomBarEvent>(_onBottomBarEvent);
  }

  void _onOpenMyCoursesPageEvent(
    OnOpenMyCoursesPageEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    await analytics.logEvent(
      name: 'on_open_my_course_page',
    );
  }

  void _onTestLogEvent(
    OnTestLogEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
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
  }

  void _onCourseSelectedEvent(
    OnCourseSelectedEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    await analytics.logEvent(
      name: 'course_selected',
      parameters: <String, dynamic>{
        'uid': event.currentCourse?.uid,
        'name': event.currentCourse?.name,
        'author': event.currentCourse?.author,
        'category': event.currentCourse?.category,
      },
    );
  }

  void _onBottomBarEvent(
    OnBottomBarEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    await analytics.logEvent(
      name: 'bottom_bar_event',
      parameters: <String, dynamic>{
        'bottomBarIndex': event.routeName,
      },
    );
  }
}
