import 'package:equatable/equatable.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';

class CourseModel extends Equatable {
  final String? uid;
  final String? name;
  final String? author;
  final String? category;
  final double? price;
  final double? duration;
  final String? about;
  final int? openLesson;
  final String? title;
  final List<LessonModel>? lessons;

  const CourseModel({
    this.uid,
    this.name,
    this.author,
    this.category,
    this.price,
    this.duration,
    this.about,
    this.openLesson,
    this.title,
    this.lessons,
  });

  const CourseModel.empty({
    this.uid,
    this.name,
    this.author,
    this.category,
    this.price,
    this.duration,
    this.about,
    this.openLesson,
    this.title,
    this.lessons,
  });

  CourseModel copyWith({
    String? uid,
    String? name,
    String? author,
    String? category,
    double? price,
    double? duration,
    String? about,
    int? openLesson,
    String? title,
    List<LessonModel>? lessons,
  }) {
    return CourseModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      author: author ?? this.author,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      about: about ?? this.about,
      openLesson: openLesson ?? this.openLesson,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    List listLesson = List<Map<String, dynamic>>.from(json['lessons'] ?? []);
    List<LessonModel> listLessons = [];

    for (Map<String, dynamic> lessonRaw in listLesson) {
      listLessons.add(
        LessonModel.fromJson(
          lessonRaw,
        ),
      );
    }

    return CourseModel(
      uid: json['uid'],
      name: json['name'],
      author: json['author'],
      category: json['category'],
      price: json['price'].toDouble(),
      duration: json['duration'].toDouble(),
      about: json['about'],
      openLesson: json['openLesson'],
      title: json['titleImage'],
      lessons: listLessons,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['author'] = author;
    data['category'] = category;
    data['price'] = price;
    data['duration'] = duration;
    data['about'] = about;
    data['openLesson'] = openLesson;
    data['title'] = title;
    data['lessons'] = lessons;
    return data;
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        author,
        category,
        price,
        duration,
        about,
        openLesson,
        title,
        lessons,
      ];
}
