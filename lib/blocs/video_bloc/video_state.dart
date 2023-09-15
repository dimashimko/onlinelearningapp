part of 'video_bloc.dart';

enum PlaybackStatus { play, pause }

class VideoState {
  const VideoState({
    this.totalDuration = 0,
    this.currentCourse,
    this.currentLessonIndex,
    this.playbackStatus = PlaybackStatus.pause,
    this.currentProgressInPercent = 0.0,
    this.lastProgressValue = 0,
    this.showStatistic = 0,
  });

  final int totalDuration;
  final String? currentCourse;
  final int? currentLessonIndex;
  final PlaybackStatus playbackStatus;
  final double currentProgressInPercent;
  final double lastProgressValue;
  final int showStatistic;

  VideoState copyWith({
    int? totalDuration,
    String? currentCourse,
    // int? currentLessonIndex,
    int? Function()? currentLessonIndex,
    PlaybackStatus? playbackStatus,
    double? currentProgressInPercent,
    double? lastProgressValue,
    int? showStatistic,
  }) {
    return VideoState(
      totalDuration: totalDuration ?? this.totalDuration,
      currentCourse: currentCourse ?? this.currentCourse,
      // currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      currentLessonIndex: currentLessonIndex != null
          ? currentLessonIndex()
          : this.currentLessonIndex,
      playbackStatus: playbackStatus ?? this.playbackStatus,
      currentProgressInPercent: currentProgressInPercent ?? this.currentProgressInPercent,
      lastProgressValue: lastProgressValue ?? this.lastProgressValue,
      showStatistic: showStatistic ?? this.showStatistic,
    );
  }
}















