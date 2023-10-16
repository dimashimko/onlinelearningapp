import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/user_activity/user_activity_model.dart';
import 'package:online_learning_app/services/firestore_progress_service.dart';
import 'package:online_learning_app/utils/constants.dart';

part 'progress_event.dart';

part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  static const int updateInterval = pushActivityUpdateInterval;
  double lastProgressValue = 0;

  ProgressBloc() : super(const ProgressState()) {
    MyFirestoreProgressService fireStoreProgressService =
        MyFirestoreProgressService();

    on<CoursePurchasedEvent>(
      (event, emit) async {
        log('*** @CoursePurchasedEvent ');

        CourseProgressModel? currentCourseProgress =
            state.userProgress?[state.currentCourseUid] ??
                const CourseProgressModel.empty();

        currentCourseProgress = currentCourseProgress.copyWith(
          bought: true,
        );
        if (state.currentCourseUid != null) {
          fireStoreProgressService.pushUserProgress(
            state.currentCourseUid!,
            currentCourseProgress,
          );
        }
        log('*** @CoursePurchasedEvent currentCourseProgress: $currentCourseProgress');
        add(GetUserProgressEvent());
      },
    );

    on<TapButtonFavorite>(
      (event, emit) async {
        log('*** @TapButtonFavorite ');

        CourseProgressModel? currentCourseProgress =
            state.userProgress?[state.currentCourseUid] ??
                const CourseProgressModel.empty();

        log('*** @TapButtonFavorite currentCourseProgress: $currentCourseProgress');
        currentCourseProgress = currentCourseProgress.copyWith(
          favorites: !(currentCourseProgress.favorites ?? true),
        );
        if (state.currentCourseUid != null) {
          fireStoreProgressService.pushUserProgress(
            state.currentCourseUid!,
            currentCourseProgress,
          );
        }
        log('*** @TapButtonFavorite currentCourseProgress: $currentCourseProgress');
        add(GetUserProgressEvent());
      },
    );

    on<UpdateUserActivityTimeEvent>(
      (event, emit) async {
        log('*** @UpdateUserActivityTimeEvent ');
        UserActivityModel? userActivityModel =
            await fireStoreProgressService.updateActivityTime(
          difference: 0,
        );
        emit(
          state.copyWith(
            userActivityModel: userActivityModel,
          ),
        );
      },
    );

    on<VideoFinishEvent>(
      (event, emit) async {
        log('*** @VideoFinishEvent ');
        bool isNeedShowStatistic =
            await fireStoreProgressService.checkNeedShowStatistic();
        log('*** isNeedShowStatistic: $isNeedShowStatistic');
        int showStatisticValue = state.showStatisticTrigger;
        showStatisticValue = showStatisticValue + 1;
        if (isNeedShowStatistic) {
          emit(
            state.copyWith(
              showStatisticTrigger: showStatisticValue,
            ),
          );
        }
      },
    );

    on<GetUserProgressEvent>(
      (event, emit) async {
        // log('*** @GetUserProgressEvent ');
        Map<String, CourseProgressModel> userProgress =
            await fireStoreProgressService.getUserProgress();
        // log('*** @GetUserProgressEvent userProgress: $userProgress');
        emit(
          state.copyWith(
            userProgress: userProgress,
          ),
        );
      },
    );

    on<ChangeProgressEvent>(
      (event, emit) async {
        // log('*** @ChangeViewProgress ');

        double difference = event.newProgressValue - lastProgressValue;
        // log('*** difference: ${difference}');
        // log('*** updateInterval: ${updateInterval}');

        // video change position
        if (difference > updateInterval * 2 || difference < 0) {
          log('*** seek video (rewind video)');
          difference = 0.0;
          lastProgressValue = event.newProgressValue;
        }

        if (difference > updateInterval) {
          // log('*** push accessed');
          if (state.currentCourseUid != null) {
            // change
            UserActivityModel? userActivityModel =
                await fireStoreProgressService.updateActivityTime(
              difference: difference,
            );
            Map<String, CourseProgressModel> userProgress =
                await fireStoreProgressService.changeProgressValue(
              newViewProgressInPercent: event.newViewProgressInPercent,
              uidOfCurrentCourse: state.currentCourseUid!,
              currentLessonIndex: state.currentLessonIndex,
            );
            emit(
              state.copyWith(
                userActivityModel: userActivityModel,
                userProgress: userProgress,
              ),
            );

            // log('*** event.newProgressValue: ${event.newProgressValue}');
            // log('*** lastProgressValue: ${lastProgressValue}');
            lastProgressValue = event.newProgressValue;
          }
        }

        emit(
          state.copyWith(
            currentProgressInPercent: event.newViewProgressInPercent,
          ),
        );
        // add(GetFilteredCourses());
      },
    );

    on<ChangePlaybackStatusEvent>(
      (event, emit) async {
        // log('*** @ChangePlaybackStatus ');
        emit(
          state.copyWith(
            playbackStatus: event.newPlaybackStatus,
          ),
        );
        // add(GetFilteredCourses());
      },
    );

    on<ChangeCurrentLessonEvent>(
      (event, emit) async {
        log('*** @ChangeCurrentLesson ');
        emit(
          state.copyWith(
            // currentLessonIndex: event.newCurrentLessonIndex,
            currentLessonIndex: () => event.newCurrentLessonIndex,
            currentProgressInPercent: 0.0,
            lastProgressValue: 0,
          ),
        );
        // add(GetFilteredCourses());
      },
    );

    on<ChangeCurrentCourseEvent>(
      (event, emit) async {
        log('*** @ChangeCurrentCourse ');
        emit(
          state.copyWith(
            currentCourseUid: event.uidCourse,
            currentLessonIndex: () => null,
            currentProgressInPercent: 0.0,
            lastProgressValue: 0,
          ),
        );
        // add(GetFilteredCourses());
      },
    );

    on<NewProgressEvent>(
      (event, emit) async {
        log('*** @NewProgress ');
      },
    );

    on<InitProgressBlocEvent>(
      (event, emit) async {
        log('*** @InitProgressBlocEvent ');
        add(
          UpdateUserActivityTimeEvent(),
        );
        add(
          GetUserProgressEvent(),
        );
      },
    );

  }
}
