part of 'video_bloc.dart';

class VideoState {
  const VideoState({
    this.totalDuration = 0,
    this.currentCourse,
    this.currentLessonIndex,
  });

  final int totalDuration;
  final String? currentCourse;
  final int? currentLessonIndex;

  VideoState copyWith(
      {int? totalDuration,
      String? currentCourse,
      // int? currentLessonIndex,
      int? Function()? currentLessonIndex}) {
    return VideoState(
      totalDuration: totalDuration ?? this.totalDuration,
      currentCourse: currentCourse ?? this.currentCourse,
      // currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      currentLessonIndex: currentLessonIndex != null
          ? currentLessonIndex()
          : this.currentLessonIndex,
    );
  }
}
