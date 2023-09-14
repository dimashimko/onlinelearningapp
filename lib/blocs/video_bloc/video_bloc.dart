import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/services/firestore_progress_service.dart';
import 'package:online_learning_app/services/firestore_service.dart';
import 'package:path_provider/path_provider.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  static const int updateInterval = 4;
  double lastProgressValue = 0;

  VideoBloc() : super(const VideoState()) {
    MyFirestoreProgressService fireStoreProgressService =
        MyFirestoreProgressService();

    on<VideoFinishEvent>(
      (event, emit) async {
        log('*** @VideoFinishEvent ');

        emit(
          state.copyWith(),
        );
        // add(GetFilteredCourses());
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
          if (state.currentCourse != null) {
            fireStoreProgressService.changeActivityTime(
              difference: difference,
            );
            fireStoreProgressService.changeProgressValue(
              newViewProgressInPercent: event.newViewProgressInPercent,
              currentCourse: state.currentCourse!,
              currentLessonIndex: state.currentLessonIndex,
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
        log('*** @ChangePlaybackStatus ');
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
            currentCourse: event.uidCourse,
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

    // on<VideoBlocInitEvent>(
    //   (event, emit) async {
    //     fireStoreService = MyFirestoreService();
    //     print('*** @VideoBlocInit ');
    //     add(GetListOfRecordEvent());
    //   },
    // );
  }
}
