import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void sendOpenMyCoursePageEvent() async {
    await analytics.logEvent(
      name: 'on_open_my_course_page',
    );
  }

  void sendCourseSelectedEvent({
    required String? uid,
    required String? name,
    required String? author,
    required String? category,
  }) async {
    await analytics.logEvent(
      name: 'course_selected',
      parameters: <String, Object>{
        'uid': uid ?? 'uid',
        'name': name ?? 'name',
        'author': author ?? 'author',
        'category': category ?? 'category',
      },
    );
  }

  void sendBottomBarEvent({
    required String? routeName,
  }) async {
    await analytics.logEvent(
      name: 'bottom_bar_event',
      parameters: <String, Object>{
        'bottomBarIndex': routeName ?? 'routeName',
      },
    );
  }

  void sendTestEvent() async {
    DateTime dateTime = DateTime.now();
    String dateTimeNow = dateTime.toString();
    String name = 'platformName';
    if (Platform.isAndroid) {
      name = 'android_dateTimeNow';
    } else if (Platform.isIOS) {
      name = 'iOS_dateTimeNow';
    }

    await analytics.logEvent(
      name: name,
      parameters: <String, Object>{
        'dateTime': dateTimeNow,
      },
    );
  }
}
