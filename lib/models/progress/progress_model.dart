import 'package:equatable/equatable.dart';

class CourseProgressModel extends Equatable {
  final bool? bought;
  final bool? favorites;
  final bool? completed;
  final Map<String, List<bool>>? lessonsProgress;

  const CourseProgressModel({
    this.bought,
    this.favorites,
    this.completed,
    this.lessonsProgress,
  });

  const CourseProgressModel.empty({
    this.bought = false,
    this.favorites = false,
    this.completed = false,
    this.lessonsProgress = const {},
  });

  @override
  List<Object?> get props => [
        bought,
        favorites,
        completed,
        lessonsProgress,
      ];

  @override
  String toString() {
    return 'bought: $bought, favorites: $favorites, completed: $completed, lessons: $lessonsProgress';
  }

  CourseProgressModel copyWith({
    bool? bought,
    bool? favorites,
    bool? completed,
    Map<String, List<bool>>? lessonsProgress,
  }) {
    return CourseProgressModel(
      bought: bought ?? this.bought,
      favorites: favorites ?? this.favorites,
      completed: completed ?? this.completed,
      lessonsProgress: lessonsProgress ?? this.lessonsProgress,
    );
  }

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<bool>> lessonsProgressMap = {};
    if (json['lessons'] != null) {
      json['lessons'].forEach((key, value) {
        final array = List<bool>.from(value);
        lessonsProgressMap.addAll({key: array});
      });
    }
    return CourseProgressModel(
      bought: json['bought'],
      favorites: json['favorites'],
      completed: json['completed'],
      lessonsProgress: lessonsProgressMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'bought': bought,
      'favorites': favorites,
      'completed': completed,
      'lessons': lessonsProgress?.map((key, value) {
        return MapEntry(key, List<dynamic>.from(value));
      }),
    };
    return json;

/*    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bought'] = this.bought;
    data['favorites'] = this.favorites;
    data['completed'] = this.completed;

    data['lessons'] = json.encode(this.lessonsProgress);
    return data;*/
  }
}
