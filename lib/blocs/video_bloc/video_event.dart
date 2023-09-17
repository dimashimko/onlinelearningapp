part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {
  const VideoEvent();
}

class PushProgressEvent extends VideoEvent {
  const PushProgressEvent({
    required this.newProgressValue,
  });

  final int newProgressValue;
}

class UpdateUserActivityTimeEvent extends VideoEvent {}

class VideoFinishEvent extends VideoEvent {}

class ChangeProgressEvent extends VideoEvent {
  const ChangeProgressEvent({
    required this.newViewProgressInPercent,
    required this.newProgressValue,
  });

  final double newViewProgressInPercent;
  final double newProgressValue;
}

class ChangePlaybackStatusEvent extends VideoEvent {
  const ChangePlaybackStatusEvent({
    required this.newPlaybackStatus,
  });

  final PlaybackStatus newPlaybackStatus;
}

class ChangeCurrentLessonEvent extends VideoEvent {
  const ChangeCurrentLessonEvent({
    required this.newCurrentLessonIndex,
  });

  final int newCurrentLessonIndex;
}

class ChangeCurrentCourseEvent extends VideoEvent {
  const ChangeCurrentCourseEvent({
    required this.uidCourse,
  });

  final String uidCourse;
}

class GetProgressEvent extends VideoEvent {}

class NewProgressEvent extends VideoEvent {
  const NewProgressEvent({
    this.uidCourse,
    this.numLesson,
    this.timePoint,
  });

  final String? uidCourse;
  final int? numLesson;
  final int? timePoint;
}

class VideoBlocInitEvent extends VideoEvent {}
