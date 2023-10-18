

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

        add(GetUserProgressEvent());
      },
    );

    on<TapButtonFavorite>(
      (event, emit) async {


        CourseProgressModel? currentCourseProgress =
            state.userProgress?[state.currentCourseUid] ??
                const CourseProgressModel.empty();

        currentCourseProgress = currentCourseProgress.copyWith(
          favorites: !(currentCourseProgress.favorites ?? true),
        );
        if (state.currentCourseUid != null) {
          fireStoreProgressService.pushUserProgress(
            state.currentCourseUid!,
            currentCourseProgress,
          );
        }

        add(GetUserProgressEvent());
      },
    );

    on<UpdateUserActivityTimeEvent>(
      (event, emit) async {

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


        bool isNeedShowStatistic =
            await fireStoreProgressService.checkNeedShowStatistic();

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

        Map<String, CourseProgressModel> userProgress =
            await fireStoreProgressService.getUserProgress();

        emit(
          state.copyWith(
            userProgress: userProgress,
          ),
        );
      },
    );

    on<ChangeProgressEvent>(
      (event, emit) async {


        double difference = event.newProgressValue - lastProgressValue;



        if (difference > updateInterval * 2 || difference < 0) {

          difference = 0.0;
          lastProgressValue = event.newProgressValue;
        }

        if (difference > updateInterval) {

          if (state.currentCourseUid != null) {

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


            lastProgressValue = event.newProgressValue;
          }
        }

        emit(
          state.copyWith(
            currentProgressInPercent: event.newViewProgressInPercent,
          ),
        );

      },
    );

    on<ChangePlaybackStatusEvent>(
      (event, emit) async {

        emit(
          state.copyWith(
            playbackStatus: event.newPlaybackStatus,
          ),
        );

      },
    );

    on<ChangeCurrentLessonEvent>(
      (event, emit) async {

        emit(
          state.copyWith(

            currentLessonIndex: () => event.newCurrentLessonIndex,
            currentProgressInPercent: 0.0,
            lastProgressValue: 0,
          ),
        );

      },
    );

    on<ChangeCurrentCourseEvent>(
      (event, emit) async {

        emit(
          state.copyWith(
            currentCourseUid: event.uidCourse,
            currentLessonIndex: () => null,
            currentProgressInPercent: 0.0,
            lastProgressValue: 0,
          ),
        );

      },
    );

    on<NewProgressEvent>(
      (event, emit) async {

      },
    );

    on<InitProgressBlocEvent>(
      (event, emit) async {

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
