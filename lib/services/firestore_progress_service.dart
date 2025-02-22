

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/user_activity/user_activity_model.dart';
import 'package:online_learning_app/utils/constants.dart';

class MyFirestoreProgressService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static const int numberOfPartOfLesson = 5;

  Future<bool> checkNeedShowStatistic() async {
    UserActivityModel? userActivityModel = await getActivityModel(); // get

    if (userActivityModel == null) {

      userActivityModel = const UserActivityModel.empty();
    }
    UserActivityModel? newUserActivityModel =
        checkLastDay(userActivityModel); // change
    if (newUserActivityModel != null) {
      pushActivityTime(
        userActivityModel: newUserActivityModel,
      ); // push
    }
    return newUserActivityModel != null;
  }

  UserActivityModel? checkLastDay(UserActivityModel userActivityModel) {
    Jiffy now = Jiffy.now().add(days: shiftDay);
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

  Future<UserActivityModel?> updateActivityTime({
    required double difference,
  }) async {
    difference = difference * pushActivityCoef;

    UserActivityModel? userActivityModel = await getActivityModel();
    if (userActivityModel == null) {

      userActivityModel = const UserActivityModel.empty();
    }

    userActivityModel = changeUserActivityModel(
      userActivityModel,
      difference,
    );

    pushActivityTime(userActivityModel: userActivityModel);

    return userActivityModel;
  }

  UserActivityModel changeUserActivityModel(
    UserActivityModel userActivityModel,
    double difference,
  ) {
    String oldDayOfYear = userActivityModel.dayOfYear ?? '';
    Jiffy now = Jiffy.now().add(days: shiftDay);
    String nowDayOfYear = '${now.year}-${now.month}-${now.date}';
    double timePerDay = userActivityModel.timePerDay ?? 0.0;
    if (nowDayOfYear == oldDayOfYear) {
      timePerDay += difference;
    } else {
      timePerDay = difference;
    }

    double totallyHours = (userActivityModel.totallyHours ?? 0.0) + difference;

    int totallyDays = userActivityModel.totallyDays ?? 0;
    if (nowDayOfYear != oldDayOfYear) totallyDays++;

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

  void pushActivityTime({
    required UserActivityModel userActivityModel,
  }) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (checkUserUid(uid)) {
      db.collection("activity").doc(uid).set(
            userActivityModel.toJson(),
          );
    }
  }

  Future<UserActivityModel?> getActivityModel() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    UserActivityModel? userActivityModel;
    if (checkUserUid(uid)) {
      DocumentSnapshot<Map<String, dynamic>> value =
          await db.collection("activity").doc(uid).get();

      if (value.data() == null) {

        db.collection("activity").doc(uid).set({});
      } else {
        userActivityModel = UserActivityModel.fromJson(value.data()!);
      }
    }
    return userActivityModel;
  }

  Future<Map<String, CourseProgressModel>> changeProgressValue({
    required double newViewProgressInPercent,
    required String uidOfCurrentCourse,
    required int? currentLessonIndex,
  }) async {
    Map<String, CourseProgressModel> userProgress = await getUserProgress();

    CourseProgressModel courseModel =
        userProgress[uidOfCurrentCourse] ?? const CourseProgressModel.empty();

    List<bool> partsOfLesson =
        courseModel.lessonsProgress!['$currentLessonIndex'] ??
            List.generate(numberOfPartOfLesson, (index) => false);

    List<bool> newPartsOfLesson = partsOfLesson.isEmpty
        ? List.generate(numberOfPartOfLesson, (index) => false)
        : [...partsOfLesson];
    int part = newViewProgressInPercent * numberOfPartOfLesson ~/ 100;
    newPartsOfLesson[part] = true;

    if (newPartsOfLesson != partsOfLesson) {
      Map<String, List<bool>> lessonsProgress = {
        ...courseModel.lessonsProgress!
      };

      lessonsProgress['$currentLessonIndex'] = newPartsOfLesson;
      courseModel = courseModel.copyWith(
        lessonsProgress: lessonsProgress,
      );

      pushUserProgress(uidOfCurrentCourse, courseModel);
    }
    userProgress[uidOfCurrentCourse] = courseModel;
    return userProgress;
  }

  void pushUserProgress(
    String uidOfCourse,
    CourseProgressModel progressModel,
  ) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (checkUserUid(uid)) {
      db.collection("progress").doc(uid).update({
        uidOfCourse: progressModel.toJson(),
      });
    }
  }

  Future<Map<String, CourseProgressModel>> getUserProgress() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    Map<String, CourseProgressModel> userProgress = {};
    if (checkUserUid(uid)) {
      DocumentSnapshot<Map<String, dynamic>> value =
          await db.collection("progress").doc(uid).get();

      if (value.data() == null) {

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
    }

    return userProgress;
  }
}

bool checkUserUid(String? uid) {
  if (uid == null) {

    return false;
  } else {
    if (uid == '0') {

      return false;
    }
  }
  return true;
}
