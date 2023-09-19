part of 'progress_bloc.dart';

enum PlaybackStatus { play, pause }

class ProgressState extends Equatable {
  const ProgressState({
    this.totalDuration = 0,
    this.currentCourseUid,
    this.currentLessonIndex,
    this.playbackStatus = PlaybackStatus.pause,
    this.currentProgressInPercent = 0.0,
    this.lastProgressValue = 0,
    this.showStatistic = 0,
    this.userActivityModel,
    this.userProgress,
  });

  //
  @override
  List<Object?> get props => [
        totalDuration,
        currentCourseUid,
        currentLessonIndex,
        playbackStatus,
        currentProgressInPercent,
        lastProgressValue,
        showStatistic,
        userActivityModel,
        userProgress,
      ];

  final int totalDuration;
  final String? currentCourseUid;
  final int? currentLessonIndex;
  final PlaybackStatus playbackStatus;
  final double currentProgressInPercent;
  final double lastProgressValue;
  final int showStatistic;
  final UserActivityModel? userActivityModel;
  final Map<String, CourseProgressModel>? userProgress;

  ProgressState copyWith({
    int? totalDuration,
    String? currentCourseUid,
    // int? currentLessonIndex,
    int? Function()? currentLessonIndex,
    PlaybackStatus? playbackStatus,
    double? currentProgressInPercent,
    double? lastProgressValue,
    int? showStatistic,
    UserActivityModel? userActivityModel,
    Map<String, CourseProgressModel>? userProgress,
  }) {
    return ProgressState(
      totalDuration: totalDuration ?? this.totalDuration,
      currentCourseUid: currentCourseUid ?? this.currentCourseUid,
      // currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      currentLessonIndex: currentLessonIndex != null
          ? currentLessonIndex()
          : this.currentLessonIndex,
      playbackStatus: playbackStatus ?? this.playbackStatus,
      currentProgressInPercent:
          currentProgressInPercent ?? this.currentProgressInPercent,
      lastProgressValue: lastProgressValue ?? this.lastProgressValue,
      showStatistic: showStatistic ?? this.showStatistic,
      userActivityModel: userActivityModel ?? this.userActivityModel,
      userProgress: userProgress ?? this.userProgress,
    );
  }
}
