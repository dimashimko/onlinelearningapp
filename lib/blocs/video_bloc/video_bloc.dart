import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    // MyFirestoreService fireStoreService = MyFirestoreService();

    on<ChangeCurrentLesson>(
      (event, emit) async {
        log('*** @ChangeCurrentLesson ');
        emit(
          state.copyWith(
            currentLessonIndex: event.newCurrentLessonIndex,
          ),
        );
        // add(GetFilteredCourses());
      },
    );

    on<ChangeCurrentCourse>(
      (event, emit) async {
        log('*** @ChangeCurrentCourse ');
        emit(
          state.copyWith(
            currentCourse: event.uidCourse,
            currentLessonIndex: null,

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
