import 'package:equatable/equatable.dart';

class UserActivityModel extends Equatable {
  final String? dayOfYear;
  final double? timePerDay;
  final double? totallyHours;
  final int? totallyDays;
  final String? weekOfYear;
  final String? lastDayShowStatistic;
  final List<bool>? recordOfThisWeek;

  const UserActivityModel({
    this.dayOfYear,
    this.timePerDay,
    this.totallyHours,
    this.totallyDays,
    this.weekOfYear,
    this.lastDayShowStatistic,
    this.recordOfThisWeek,
  });

  const UserActivityModel.empty({
    this.dayOfYear = '',
    this.timePerDay = 0,
    this.totallyHours = 0,
    this.totallyDays = 0,
    this.weekOfYear = '',
    this.lastDayShowStatistic = '',
    this.recordOfThisWeek = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
  });

  UserActivityModel copyWith({
    String? dayOfYear,
    double? timePerDay,
    double? totallyHours,
    int? totallyDays,
    String? weekOfYear,
    String? lastDayShowStatistic,
    List<bool>? recordOfThisWeek,
  }) {
    return UserActivityModel(
      dayOfYear: dayOfYear ?? this.dayOfYear,
      timePerDay: timePerDay ?? this.timePerDay,
      totallyHours: totallyHours ?? this.totallyHours,
      totallyDays: totallyDays ?? this.totallyDays,
      weekOfYear: weekOfYear ?? this.weekOfYear,
      lastDayShowStatistic: lastDayShowStatistic ?? this.lastDayShowStatistic,
      recordOfThisWeek: recordOfThisWeek ?? this.recordOfThisWeek,
    );
  }

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    List<bool>? recordOfThisWeek;
    if (json['recordOfThisWeek'] != null) {
      recordOfThisWeek = List<bool>.from(json['recordOfThisWeek']);
    }
    return UserActivityModel(
      dayOfYear: json['dayOfYear'],
      timePerDay: json['timePerDay'],
      totallyHours: json['totallyHours'],
      totallyDays: json['totallyDays'],
      weekOfYear: json['weekOfYear'],
      lastDayShowStatistic: json['lastDayShowStatistic'],
      recordOfThisWeek: recordOfThisWeek,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> outputJson = {
      'dayOfYear': dayOfYear,
      'timePerDay': timePerDay,
      'totallyHours': totallyHours,
      'totallyDays': totallyDays,
      'weekOfYear': weekOfYear,
      'lastDayShowStatistic': lastDayShowStatistic,
      'recordOfThisWeek': List<dynamic>.from(recordOfThisWeek ?? []),
    };
    return outputJson;
  }

  @override
  List<Object?> get props => [
        dayOfYear,
        timePerDay,
        totallyHours,
        totallyDays,
        weekOfYear,
        lastDayShowStatistic,
        recordOfThisWeek
      ];
}
