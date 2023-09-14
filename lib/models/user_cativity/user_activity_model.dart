import 'dart:convert';

class UserActivityModel {
  String? dayOfYear;
  double? timePerDay;
  double? totallyHours;
  int? totallyDays;
  String? weekOfYear;
  List<bool>? recordOfThisWeek;

  UserActivityModel({
    this.dayOfYear,
    this.timePerDay,
    this.totallyHours,
    this.totallyDays,
    this.weekOfYear,
    this.recordOfThisWeek,
  });

  UserActivityModel.empty({
    this.dayOfYear = '',
    this.timePerDay = 0,
    this.totallyHours = 0,
    this.totallyDays = 0,
    this.weekOfYear = '',
    this.recordOfThisWeek = const [false, false, false, false, false, false, false],
  });

  @override
  String toString() {
    return 'dayOfYear: $dayOfYear, timePerDay: $timePerDay, totallyHours: $totallyHours, totallyDays: $totallyDays, weekOfYear: $weekOfYear, lessons: $recordOfThisWeek';
  }

  UserActivityModel copyWith({
    String? dayOfYear,
    double? timePerDay,
    double? totallyHours,
    int? totallyDays,
    String? weekOfYear,
    List<bool>? recordOfThisWeek,
  }) {
    return UserActivityModel(
      dayOfYear: dayOfYear ?? this.dayOfYear,
      timePerDay: timePerDay ?? this.timePerDay,
      totallyHours: totallyHours ?? this.totallyHours,
      totallyDays: totallyDays ?? this.totallyDays,
      weekOfYear: weekOfYear ?? this.weekOfYear,
      recordOfThisWeek: recordOfThisWeek ?? this.recordOfThisWeek,
    );
  }



  UserActivityModel.fromJson(Map<String, dynamic> json) {
    dayOfYear = json['dayOfYear'];
    timePerDay = json['timePerDay'];
    totallyHours = json['totallyHours'];
    totallyDays = json['totallyDays'];
    weekOfYear = json['weekOfYear'];
    recordOfThisWeek = List<bool>.from(json['recordOfThisWeek']);
    // recordOfThisWeek = recordOfThisWeekMap;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> outputJson = {
      'dayOfYear': this.dayOfYear,
      'timePerDay': this.timePerDay,
      'totallyHours': this.totallyHours,
      'totallyDays': this.totallyDays,
      'weekOfYear': this.weekOfYear,
      // 'recordOfThisWeek': json.encode(recordOfThisWeek),
      'recordOfThisWeek': List<dynamic>.from(recordOfThisWeek??[]),
    };
    return outputJson;
  }
}
