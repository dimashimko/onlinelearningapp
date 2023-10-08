part of 'analytics_bloc.dart';

@immutable
abstract class AnalyticsEvent {
  const AnalyticsEvent();
}

class OnCourseSelectedEvent extends AnalyticsEvent {
  const OnCourseSelectedEvent({
    required this.currentCourse,
  });

  final CourseModel? currentCourse;
}

class OnBottomBarEvent extends AnalyticsEvent {
  const OnBottomBarEvent({
    required this.routeName,
  });

  final String routeName;
}

class OnTestLogEvent extends AnalyticsEvent {}

class OnOpenMyCoursesPageEvent extends AnalyticsEvent {}
