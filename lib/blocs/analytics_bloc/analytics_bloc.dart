import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/services/analytics_service.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final AnalyticsService analyticsService = AnalyticsService();

  AnalyticsBloc() : super(const AnalyticsState()) {
    on<OnOpenMyCoursesPageEvent>(_onOpenMyCoursesPageEvent);
    on<OnCourseSelectedEvent>(_onCourseSelectedEvent);
    on<OnBottomBarEvent>(_onBottomBarEvent);
    on<OnTestLogEvent>(_onTestLogEvent);
  }

  void _onOpenMyCoursesPageEvent(
    OnOpenMyCoursesPageEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    analyticsService.sendOpenMyCoursePageEvent();
  }

  void _onCourseSelectedEvent(
    OnCourseSelectedEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    analyticsService.sendCourseSelectedEvent(
      uid: event.currentCourse?.uid,
      name: event.currentCourse?.name,
      author: event.currentCourse?.author,
      category: event.currentCourse?.category,
    );
  }

  void _onBottomBarEvent(
    OnBottomBarEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    analyticsService.sendBottomBarEvent(
      routeName: event.routeName,
    );
  }

  void _onTestLogEvent(
    OnTestLogEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    analyticsService.sendTestEvent();
  }
}
