part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {
  const VideoEvent();
}

class ChangeCurrentLesson extends VideoEvent {
  const ChangeCurrentLesson({
    required this.newCurrentLessonIndex,
  });

  final int newCurrentLessonIndex;
}

class ChangeCurrentCourse extends VideoEvent {
  const ChangeCurrentCourse({
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
