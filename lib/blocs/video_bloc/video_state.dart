part of 'video_bloc.dart';

enum PlaybackStatus { play, pause }

class VideoState {
  const VideoState({
    this.totalDuration = 0,
    this.currentCourse,
    this.currentLessonIndex,
    this.playbackStatus = PlaybackStatus.pause,
    this.currentViewProgress = 0.0,
  });

  final int totalDuration;
  final String? currentCourse;
  final int? currentLessonIndex;
  final PlaybackStatus playbackStatus;
  final double currentViewProgress;

  VideoState copyWith({
    int? totalDuration,
    String? currentCourse,
    // int? currentLessonIndex,
    int? Function()? currentLessonIndex,
    PlaybackStatus? playbackStatus,
    double? currentViewProgress,
  }) {
    return VideoState(
      totalDuration: totalDuration ?? this.totalDuration,
      currentCourse: currentCourse ?? this.currentCourse,
      // currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      currentLessonIndex: currentLessonIndex != null
          ? currentLessonIndex()
          : this.currentLessonIndex,
      playbackStatus: playbackStatus ?? this.playbackStatus,
      currentViewProgress: currentViewProgress ?? this.currentViewProgress,
    );
  }
}















