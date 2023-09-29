import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';

main() {
/*  print(Jiffy.now().dayOfYear); // 256
  print(DateTime.timestamp()); // 2023-09-13 17:57:55.559095Z
  print(Jiffy.now().weekOfYear); // 37
  print(Jiffy.now().yMd); // 9/13/2023
  print(Jiffy.now().dayOfWeek); // 4
  print(Jiffy.parseFromList([2023, 09, 11]).dayOfWeek); // 2*/

  //
  print('*** CourseProgressModel');
  CourseProgressModel courseProgressModel1 = CourseProgressModel(
    bought: true,
    favorites: true,
    completed: true,
  );
  CourseProgressModel courseProgressModel2 = CourseProgressModel(
    bought: true,
    favorites: true,
    completed: true,
  );
  print(courseProgressModel1 == courseProgressModel2);
  print(courseProgressModel1.toString() == courseProgressModel2.toString());



}
