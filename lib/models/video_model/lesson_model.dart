import 'package:equatable/equatable.dart';

class LessonModel extends Equatable {
  final String? link;
  final String? name;
  final double? duration;

  const LessonModel({
    this.link,
    this.name,
    this.duration,
  });

  const LessonModel.empty({
    this.link,
    this.name,
    this.duration,
  });

  LessonModel copyWith({
    String? link,
    String? name,
    double? duration,
  }) {
    return LessonModel(
      link: link ?? this.link,
      name: name ?? this.name,
      duration: duration ?? this.duration,
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      link: json['link'],
      name: json['name'],
      duration: json['duration'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['name'] = name;
    data['duration'] = duration;
    return data;
  }

  @override
  List<Object?> get props => [
        link,
        name,
        duration,
      ];
}
