import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/user_cativity/user_activity_model.dart';
import 'package:online_learning_app/utils/constants.dart';

class MyFirestoreProgressService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static const int numberOfPartOfLesson = 5;

  // *****************************
  // **** ShowStatistic ******
  // *****************************
  Future<bool> checkNeedShowStatistic() async {
    UserActivityModel? userActivityModel = await getActivityTime(); // get
    // log('*** userActivityModel: $userActivityModel');

    if (userActivityModel == null) {
      log('*** Failed to get UserActivityModel');
      userActivityModel = UserActivityModel.empty();
    }
    UserActivityModel? newUserActivityModel =
        checkLastDay(userActivityModel); // change
    if (newUserActivityModel != null) {
      pushActivityTime(userActivityModel: newUserActivityModel); // push
    }
    return newUserActivityModel != null;
  }

  UserActivityModel? checkLastDay(UserActivityModel userActivityModel) {
    Jiffy now = Jiffy.now().add(days: 3);
    String nowDayOfYear = '${now.year}-${now.month}-${now.date}';
    if ((userActivityModel.lastDayShowStatistic ?? '') == nowDayOfYear) {
      return null;
    } else {
      userActivityModel = userActivityModel.copyWith(
        lastDayShowStatistic: nowDayOfYear,
      );
      return userActivityModel;
    }
  }

  // *****************************
  // **** ActivityTime ******
  // *****************************

  void changeActivityTime({
    required double difference,
  }) async {
    difference = difference * pushActivityCoef;
    UserActivityModel? userActivityModel = await getActivityTime(); // get
    // log('*** userActivityModel: $userActivityModel');

    if (userActivityModel == null) {
      log('*** Failed to get UserActivityModel');
      userActivityModel = UserActivityModel.empty();
    }
    userActivityModel =
        changeUserActivityModel(userActivityModel, difference); // change
    pushActivityTime(userActivityModel: userActivityModel); // push
  }

  UserActivityModel changeUserActivityModel(
    UserActivityModel userActivityModel,
    double difference,
  ) {
    // log('*** difference: $difference');
    // log('*** Jiffy.getSupportedLocales(): ${Jiffy.getSupportedLocales()}');

    // timePerDay
    String oldDayOfYear = userActivityModel.dayOfYear ?? '';
    Jiffy now = Jiffy.now().add(days: shiftDay);
    String nowDayOfYear = '${now.year}-${now.month}-${now.date}';
    double timePerDay = userActivityModel.timePerDay ?? 0.0;
    if (nowDayOfYear == oldDayOfYear) {
      timePerDay += difference;
    } else {
      timePerDay = difference;
    }

    // totallyHours
    double totallyHours = (userActivityModel.totallyHours ?? 0.0) + difference;

    // totallyDays
    int totallyDays = userActivityModel.totallyDays ?? 0;
    if (nowDayOfYear != oldDayOfYear) totallyDays++;

    // recordOfThisWeek
    List<bool> recordOfThisWeek = userActivityModel.recordOfThisWeek ??
        List.generate(7, (index) => false);
    String oldWeekOfYear = userActivityModel.weekOfYear ?? '';
    String nowWeekOfYear = '${now.year}-${now.weekOfYear}';
    if (oldWeekOfYear != nowWeekOfYear) {
      recordOfThisWeek = List.generate(7, (index) => false);
    }
    recordOfThisWeek[now.dayOfWeek - 1] = true;

    return userActivityModel.copyWith(
      dayOfYear: nowDayOfYear,
      timePerDay: timePerDay,
      totallyHours: totallyHours,
      totallyDays: totallyDays,
      weekOfYear: nowWeekOfYear,
      recordOfThisWeek: recordOfThisWeek,
    );
  }

  Future<Map<String, CourseProgressModel>> pushActivityTime({
    required UserActivityModel userActivityModel,
  }) async {
    // log('*** updateActivityTime');
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    Map<String, CourseProgressModel> userProgress = {};
    if (uid == null) {
      log('*** !!! progress not update from firestore: uid == null');
    } else {
      if (uid == '0') {
        log('*** progress not update from firestore: uid == \'0\'');
      } else {
        db.collection("activity").doc(uid).set(
              userActivityModel.toJson(),
            );
      }
    }
    return userProgress;
  }

  Future<UserActivityModel?> getActivityTime() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    UserActivityModel? userActivityModel;
    if (uid == null) {
      log('*** !!! progress not update from firestore: uid == null');
    } else {
      if (uid == '0') {
        log('*** progress not update from firestore: uid == \'0\'');
      } else {
        await db.collection("activity").doc(uid).get().then(
          (value) {
            if (value.data() == null) {
              log('*** value.data() == null');
              db.collection("activity").doc(uid).set({});
            } else {
              // log('*** value.data(): ${value.data()}');
              userActivityModel = UserActivityModel.fromJson(value.data()!);
/*              for (var jsonModel in value.data()!.entries) {
                userProgress.addAll({
                  jsonModel.key: CourseProgressModel.fromJson(
                    jsonModel.value,
                  )
                });
              }*/
            }
          },
        );
      }
    }
    return userActivityModel;
    // userProgress.forEach((key, value) {log('*** $key : $value');});
    // return null;
  }

  // *****************************
  // **** Progress ******
  // *****************************
  void changeProgressValue({
    required double newViewProgressInPercent,
    required String currentCourse,
    required int? currentLessonIndex,
  }) async {
    // get last version of current model
    Map<String, CourseProgressModel> userProgress = await getUserProgress();
    // log('*** userProgress: $userProgress');
    CourseProgressModel courseModel =
        userProgress[currentCourse] ?? CourseProgressModel.empty();
    // log('*** courseModel: $courseModel');
    List<bool> partsOfLesson =
        courseModel.lessonsProgress!['$currentLessonIndex'] ??
            List.generate(numberOfPartOfLesson, (index) => false);
    // log('*** partsOfLesson: $partsOfLesson');

    // do copy and mark the current part of the video as watched
    List<bool> newPartsOfLesson = partsOfLesson.isEmpty
        ? List.generate(numberOfPartOfLesson, (index) => false)
        : [...partsOfLesson];
    int part = newViewProgressInPercent * numberOfPartOfLesson ~/ 100;
    newPartsOfLesson[part] = true;

    // if something has changed, send it to the server
    if (newPartsOfLesson != partsOfLesson) {
      Map<String, List<bool>> lessonsProgress = {
        ...courseModel.lessonsProgress!
      };
      // change of current lesson in map of lessons
      lessonsProgress['$currentLessonIndex'] = newPartsOfLesson;
      courseModel = courseModel.copyWith(
        lessonsProgress: lessonsProgress,
      );

      // push new model to the server
      updateUserProgress(currentCourse, courseModel);
    }
  }

  Future<Map<String, CourseProgressModel>> updateUserProgress(
    String uidOfCourse,
    CourseProgressModel progressModel,
  ) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    Map<String, CourseProgressModel> userProgress = {};
    if (uid == null) {
      log('*** !!! progress not update from firestore: uid == null');
    } else {
      if (uid == '0') {
        log('*** progress not update from firestore: uid == \'0\'');
      } else {
        db.collection("progress").doc(uid).update({
          uidOfCourse: progressModel.toJson(),
/*          uidOfCourse: {
            "bought": false,
            "favorites": false,
            "completed": false,
            "lessons": {
              "1": [false, false, false, false, false],
              "2": [false, false, false, false, false],
            },
          },*/
        });
      }
    }
    // userProgress.forEach((key, value) {log('*** $key : $value');});
    return userProgress;
  }

  Future<Map<String, CourseProgressModel>> getUserProgress() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    Map<String, CourseProgressModel> userProgress = {};
    if (uid == null) {
      log('*** !!! progress not update from firestore: uid == null');
    } else {
      if (uid == '0') {
        log('*** progress not update from firestore: uid == \'0\'');
      } else {
        await db.collection("progress").doc(uid).get().then(
          (value) {
            if (value.data() == null) {
              log('*** value.data() == null');
              db.collection("progress").doc(uid).set({});
            } else {
              for (var jsonModel in value.data()!.entries) {
                userProgress.addAll({
                  jsonModel.key: CourseProgressModel.fromJson(
                    jsonModel.value,
                  )
                });
              }
            }
          },
        );
      }
    }
    // userProgress.forEach((key, value) {log('*** $key : $value');});
    return userProgress;
  }
}
