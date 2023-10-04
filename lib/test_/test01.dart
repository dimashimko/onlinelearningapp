import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';

String formatTime(DateTime dateTime) {
  String formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat.jm().format(dateTime);

  if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
    return formattedTime; // Return time only if it's today
  } else {
    String formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);
    return formattedDate; // Return date and time if it's not today
  }
}

main() {

  DateTime now = DateTime.now();
  DateTime someDate = DateTime(2023, 10, 3); // Example date

  String formattedDateTime = formatDateTime(now);
  String formattedDate = formatDateTime(someDate);

  print(formattedDateTime); // Output: 3:30 PM
  print(formattedDate); // Output: Oct 4, 2023 3:30 PM

/*  String timeStr = '2023-10-04T05:05:58.509Z';
  DateTime dataTime = DateTime.parse(timeStr);
  print('*** dataTime: $dataTime');
  print('*** dataTime day: ${dataTime.day}');
  print('*** dataTime day: ${dataTime.day}');

  String formattedTime = formatTime(dataTime);
  print(formattedTime); // Output: 3:30 PM*/

/*  print(Jiffy.now().dayOfYear); // 256
  print(DateTime.timestamp()); // 2023-09-13 17:57:55.559095Z
  print(Jiffy.now().weekOfYear); // 37
  print(Jiffy.now().yMd); // 9/13/2023
  print(Jiffy.now().dayOfWeek); // 4
  print(Jiffy.parseFromList([2023, 09, 11]).dayOfWeek); // 2*/

  //
/*
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
*/
}
