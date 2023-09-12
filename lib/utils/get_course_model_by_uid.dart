import 'dart:developer';

import 'package:online_learning_app/models/course/course_model.dart';

CourseModel? getCourseModelByUid(String uid, List<CourseModel> list){
  // return null;
  for (CourseModel course in list) {
    if(course.uid == uid) return course;
  }
  return null;
}