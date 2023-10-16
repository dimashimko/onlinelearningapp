part of 'progress_bloc.dart';

@immutable
abstract class ProgressEvent {
  const ProgressEvent();
}

class InitProgressBlocEvent extends ProgressEvent {}

class CoursePurchasedEvent extends ProgressEvent {}

class TapButtonFavorite extends ProgressEvent {}

class GetUserProgressEvent extends ProgressEvent {}

class UpdateUserActivityTimeEvent extends ProgressEvent {}

class VideoFinishEvent extends ProgressEvent {}

class ChangeProgressEvent extends ProgressEvent {
  const ChangeProgressEvent({
    required this.newViewProgressInPercent,
    required this.newProgressValue,
  });

  final double newViewProgressInPercent;
  final double newProgressValue;
}

class ChangePlaybackStatusEvent extends ProgressEvent {
  const ChangePlaybackStatusEvent({
    required this.newPlaybackStatus,
  });

  final PlaybackStatus newPlaybackStatus;
}

class ChangeCurrentLessonEvent extends ProgressEvent {
  const ChangeCurrentLessonEvent({
    required this.newCurrentLessonIndex,
  });

  final int newCurrentLessonIndex;
}

class ChangeCurrentCourseEvent extends ProgressEvent {
  const ChangeCurrentCourseEvent({
    required this.uidCourse,
  });

  final String uidCourse;
}

class GetProgressEvent extends ProgressEvent {}

class NewProgressEvent extends ProgressEvent {
  const NewProgressEvent({
    this.uidCourse,
    this.numLesson,
    this.timePoint,
  });

  final String? uidCourse;
  final int? numLesson;
  final int? timePoint;
}

class ProgressBlocInitEvent extends ProgressEvent {}
