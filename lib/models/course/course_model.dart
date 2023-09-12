import 'dart:developer';

import 'package:online_learning_app/models/video_model/lesson_model.dart';

enum Categories { programming, math, painting, language, other }

class CourseModel {
  String? uid;
  String? name;
  String? author;
  String? category;
  double? price;
  double? duration;
  String? about;
  int? openLesson;
  String? title;
  List<LessonModel>? lessons;

  CourseModel({
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

  @override
  String toString() {
    return ' uid: $uid, name: $name, author: $author, category: $category, price: $price, duration: $duration, openLesson: $openLesson, lessonsLength: ${lessons?.length}';
  }

  CourseModel.empty({
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

  CourseModel.fromJson(Map<String, dynamic> json) {
    // parse category
/*    Categories? category;
    log('*** json[category]: ${json['category']}');
    if (json['category'] != null) {
      log('*** json[category][name]: ${json['category']['name']}');
      if (json['category']['name'] != null) {
        category = Categories.values.byName(
          json['category'],
        );
      }
    }*/

    // parse lessons
    // List listLesson = List<dynamic>.from(json['lessons']);
    List listLesson = List<Map<String, dynamic>>.from(json['lessons'] ?? []);
    // log('*** listLesson: ${listLesson}');

/*    final Map<String, dynamic> listLessonsRaw =
        json['lessons'] as Map<String, dynamic>;*/
    List<LessonModel> listLessons = [];

    for (Map<String, dynamic> lessonRaw in listLesson) {
      // log('*** lessonRaw: $lessonRaw');
      listLessons.add(
        LessonModel.fromJson(
          lessonRaw,
        ),
      );
    }
/*    for (MapEntry<String, dynamic> lessonRaw in listLessonsRaw.entries) {
      listLessons.add(
        LessonModel.fromJson(
          lessonRaw.value,
        ),
      );
    }*/

    // log('json: $json');
    uid = json['uid'];
    name = json['name'];
    author = json['author'];
    category = json['category'];
    price = json['price'].toDouble();
    duration = json['duration'].toDouble();
    about = json['about'];
    openLesson = json['openLesson'];
    title = json['titleImage'];
    lessons = listLessons;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['author'] = this.author;
    data['category'] = this.category;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['about'] = this.about;
    data['openLesson'] = this.openLesson;
    data['title'] = this.title;
    data['lessons'] = this.lessons;
    return data;
  }
}
