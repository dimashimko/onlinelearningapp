import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range/duration_range.dart';

class MyFirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<CourseModel>> getFilteredCoursesList({
    required List<String> uidsSelectedCategories,
    required double minPrice,
    required double maxPrice,
    required List<DurationRange> filterDurationItems,
    required String searchKey,
    required FilterEnabledType filterEnabledType,
  }) async {
    // print('*** getFilteredCoursesList');
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<CourseModel> listOfCoursesModel = [];
    Query<Map<String, dynamic>> filteredCourses = db.collection('courses');
/*        // Filtered by Name v1
        filteredCourses = filteredCourses
            .where('name', isGreaterThanOrEqualTo: searchKey)
            .where('name', isLessThan: searchKey + 'z');*/

    // Filtered by Name v2
    if (filterEnabledType == FilterEnabledType.text) {
      log('*** searchKey: $searchKey');
      if (true) {
        filteredCourses = filteredCourses
            .orderBy('name')
            .startAt([searchKey]).endAt([searchKey + '\uf8ff']);
      }
    }

    // Filtered by category
    // if (filterEnabledType == FilterEnabledType.categories) {
    if (true) {
      if (uidsSelectedCategories.isNotEmpty) {
        filteredCourses = filteredCourses.where(
          'category',
          whereIn: uidsSelectedCategories,
        );
      }
    }

    // Filtered by Price
    if (filterEnabledType == FilterEnabledType.price) {
      // if (true) {
      filteredCourses = filteredCourses.where('price', isGreaterThan: minPrice);
      filteredCourses =
          filteredCourses.where('price', isLessThan: maxPrice + 0.5);
    }

    // Filtered by duration
    if (filterEnabledType == FilterEnabledType.duration) {
      // if (true) {
      for (DurationRange durationFilter in filterDurationItems) {
        if (durationFilter.isEnable) {
          log('*** durationFilter: $durationFilter');
          filteredCourses = filteredCourses
              .where(
                'duration',
                isGreaterThan: durationFilter.min * 3600,
              )
              .orderBy('duration');
          filteredCourses = filteredCourses.where(
            'duration',
            isLessThan: durationFilter.max * 3600,
          );
        }
      }
    }

    await filteredCourses.get().then(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        for (var doc in snapshot.docs) {
          listOfCoursesModel.add(
            CourseModel.fromJson(
              doc.data()..addAll({'uid': doc.id.toString()}),
            ),
          );
        }
      },
    );
    // log('*** listOfCoursesModel: ${listOfCoursesModel}');
    return listOfCoursesModel;
  }

  Future<List<CourseModel>> getAllCoursesList(String orderBy) async {
    List<CourseModel> listOfCoursesModel = [];
    Query<Map<String, dynamic>> coursesCollection =
        db.collection('courses').orderBy(orderBy);

    await coursesCollection.get().then(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        for (var doc in snapshot.docs) {
          // log('*** doc.data(): ${doc.data()}');

          listOfCoursesModel.add(
            CourseModel.fromJson(
              doc.data()..addAll({'uid': doc.id.toString()}),
            ),
          );
        }
      },
    );
    return listOfCoursesModel;
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> listOfCategoryModel = [];
    await db.collection('categories').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          listOfCategoryModel.add(
            CategoryModel.fromJson(
              doc.data()..addAll({'uid': doc.id.toString()}),
            ),
          );
        }
      },
    );
    return listOfCategoryModel;
  }

  Future<void> fillCourses() async {
/*    db.collection("progress").doc("eLC2uAmaA8VUvslkqNiqY1K8F6l2").set({
      "1691069121": {
        "bought": false,
        "favorites": false,
        "completed": false,
        "lessons": {
          "1": [true, true, true, true, true],
          "2": [true, true, true, false, false],
        },
      },
    });
    db.collection("progress").doc("eLC2uAmaA8VUvslkqNiqY1K8F6l2").set({
      "1691069121": {
        "bought": false,
        "favorites": false,
        "completed": false,
        "lessons": {
          "1": [true, true, true, true, true],
          "2": [true, true, true, false, false],
        },
      },
    });*/
    //
/*    db.collection("users").doc("eLC2uAmaA8VUvslkqNiqY1K8F6l2").set({
      "learned_today": 360,
      "today": '2023_09_08',
      "courses": {
        "course1": {
          "bought": true,
          "favorites": false,
          "completed": false,
          "progress": [true, true, true, true, false],
        },
        "course2": {
          "bought": true,
          "favorites": true,
          "completed": false,
          "progress": [true, false, false, false, false],
        },
      },
    });
    db.collection("users").doc("6rKzQ5xAInd7dodC9bR2Fy7EbBI2").set({
      "courses": {
        "course1": {
          "bought": true,
          "favorites": false,
          "lessons": [true, true, true, true, false],
        },
        "course2": {
          "bought": false,
          "favorites": true,
          "lessons": [true, false, false, false, false],
        },
      },
    });*/
    // db.collection("users").doc("6rKzQ5xAInd7dodC9bR2Fy7EbBI2").set({
    //   "uid": "6rKzQ5xAInd7dodC9bR2Fy7EbBI2",
    //   "created": 0,
    // });
    // db.collection("u").doc().set({"uid": "rwIfbhET42cvzH9QADWEqEUPHZb2", "created": 0});
    // db.collection("u").doc().set({"uid": "RsxxVMwgvOTVHra0tsG2lTXur2q1", "created": 0});
    // return;
    // db.collection("authors").doc('1691376989').set({"name": "Andrey Markov"});
    // db.collection("authors").doc('1691377035').set({"name": "VideoSmile"});
    // db.collection("authors").doc('1691377101').set({"name": "Zakhariychenko"});
    // db.collection("authors").doc('1691400957').set({"name": "Bebris"});
    //
    // db.collection("categories").doc().set({"name": Categories.painting.name});
    // db.collection("categories").doc().set({"name": Categories.language.name});
    // db
    //     .collection("categories")
    //     .doc()
    //     .set({"name": Categories.programming.name});
    // db.collection("categories").doc().set({"name": Categories.math.name});
    // db.collection("categories").doc().set({"name": Categories.other.name});
/*

    db.collection("courses").doc('1691069119').set({
      "name": "Повний курс математики в тестах",
      "author": "Zakhariychenko",
      "category": 'GEPNu5sLLWQkdlNTbrxZ',
      "price": 50.0,
      "created": '2023-09-10T05:54:08.957Z',
      "duration": 1000.0, // (60*7+7)+(60*7+29)+(60*8+56)+(60*5+24)+(60*7+32)
      "about":
          'Канал для всіх хто хоче опанувати складну, але цікаву науку математику. Ми допоможемо краще зрозуміти теми, теореми та визначення з алгебри та геометрії, покажемо розвязки типових задач, та допоможемо підготуватися до ЗНО та ДПА. Ще більше інформації для учнів та вчителів шукайте на нашому сайті',
      "openLesson": 2,
      "titleImage":
          'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/titles%2FTsili%20i%20drobovi%20ratsional%CA%B9ni%20vyrazy.png?alt=media&token=f301c2b3-df86-4ff2-ac86-0e8a82795ecf',
      "lessons": [
        {
          "duration": 4.0,
          "name": "Math lessons01",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2021-26.%20%D0%97%D0%B0%D1%85%D0%B0%D1%80%D1%96%D0%B9%D1%87%D0%B5%D0%BD%D0%BA%D0%BE.mp4?alt=media&token=01473cf6-ac2b-436b-aef7-cbab0ec73dc7',
        },
        {
          "duration": 4.0,
          "name": "Math lessons02",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2031-34.%20%D0%97%D0%B0%D1%85%D0%B0%D1%80%D1%96%D0%B9%D1%87%D0%B5%D0%BD%D0%BA%D0%BE.mp4?alt=media&token=3c03e04c-96ee-45bc-be44-21be955dceab',
        },
        {
          "duration": 4.0,
          "name": "Math lessons03",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2035-40%20%20%D0%97%D0%B0%D1%85%D0%B0%D1%80%D1%96%D0%B9%D1%87%D0%B5%D0%BD%D0%BA%D0%BE.mp4?alt=media&token=322a3a15-df57-4ef7-90d5-3e16a8cfa1c9',
        },
        {
          "duration": 4.0,
          "name": "Math lessons04",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2041-48%20%20%D0%97%D0%B0%D1%85%D0%B0%D1%80%D1%96%D0%B9%D1%87%D0%B5%D0%BD%D0%BA%D0%BE.mp4?alt=media&token=f14658fb-99bb-4191-80a1-690b652637da',
        },
        {
          "duration": 4.0,
          "name": "Math lessons05",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2049-50%2C%2063-64.%20%D0%97%D0%B0%D1%85%D0%B0%D1%80.mp4?alt=media&token=80c0098e-6417-4a31-9df9-ac566af6214e',
        },
      ],
    }).onError((e, _) => log("Error writing document: $e"));

    db.collection("courses").doc('1691069121').set({
      "name": "Dart (Flutter)",
      "author": "VideoSmile",
      "category": 'eG6sxmNL1W4SZI20cdRz',
      "price": 70.0,
      "created": '2023-09-09T05:54:08.957Z',
      "duration": 20000.0, // 14.47 + 8.13 + 11.15 + 4.11 + 4.18
      "about": 'Основы языка программирования Dart максимально простым языком',
      "openLesson": 2,
      "titleImage":
          'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/titles%2FDart%20(course%20in%20simple%20words).png?alt=media&token=951c0ef3-3c80-472c-bc13-a597c662116e',
      "lessons": [
        {
          "duration": 887.0,
          "name": "Dart lessons01",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2FDart%20(Flutter)01%20-%20%D1%82%D0%B8%D0%BF%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%20%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85%20(%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D0%BE%D0%B2).mp4?alt=media&token=275172cc-94f8-43b5-80e9-8c0c11bd84f8',
        },
        {
          "duration": 493.0,
          "name": "Dart lessons02",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2FDart%20(Flutter)02%20-%20var%2C%20dynamic%2C%20final%2C%20const%20(%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D0%BE%D0%B2).mp4?alt=media&token=299a2871-196e-4218-84b6-2f9e97297a0c',
        },
        {
          "duration": 675.0,
          "name": "Dart lessons03",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2FDart%20(Flutter)03%20-%20%D0%A1%D0%BF%D0%B8%D1%81%D0%BA%D0%B8%20List%2C%20Set%2C%20Map%20(%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D0%BE%D0%B2).mp4?alt=media&token=f9f1237c-9a15-43cc-a2f2-631f9131874b',
        },
        {
          "duration": 251.0,
          "name": "Dart lessons04",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2FDart%20(Flutter)04%20-%20%D0%9E%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D0%B8%20%D0%B2%D0%B8%D0%B4%D0%B8%D0%BC%D0%BE%D1%81%D1%82%D0%B8%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85%20(%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8%20%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D0%B0%D0%BC).mp4?alt=media&token=d0a8668c-c6ac-4b2e-8753-a8725a587d76',
        },
        {
          "duration": 258.0,
          "name": "Dart lessons05",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2FDart%20(Flutter)05%20Null%20Safety%2C%20%D1%87%D1%82%D0%BE%20%D1%8D%D1%82%D0%BE%20%D0%B8%20%D1%81%D0%BC%D1%8B%D1%81%D0%BB%20%D0%BD%D1%83%D0%BB%D0%B5%D0%B2%D0%BE%D0%B9%20%D0%B1%D0%B5%D0%B7%D0%BE%D0%BF%D0%B0%D1%81%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20(%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%BD%D0%BE%D0%B2%D0%B8%D1%87%D0%BA%D0%BE%D0%B2).mp4?alt=media&token=1964eb47-7ef5-453c-a585-b53c97ea4c57',
        },
      ],
    }).onError((e, _) => log("Error writing document: $e"));

    db.collection("courses").doc('1691376811').set({
      "name": "Азбука Рисования",
      "author": "Andrey Markov",
      "category": 'WT5Y6BT80VHtFxPpLbIZ',
      "price": 30.0,
      "created": '2023-09-08T05:54:08.957Z',
      "duration": 50000.0, // (6+17+5)*60+41+53+13
      "about":
          'Все уроки по рисованию в одном месте. Разбираю теорию и практику по теме в каждом видео.',
      "openLesson": 1,
      "titleImage":
          'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/titles%2FDrawing%20lessons.png?alt=media&token=637686da-3528-4e13-9683-ebc04663174a',
      "lessons": [
        {
          "duration": 401.0,
          "name": "Азбука Рисования 1",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%90%D0%B7%D0%B1%D1%83%D0%BA%D0%B0%20%D0%A0%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%2001%20%D0%9A%D0%B0%D0%BA%20%D0%B2%D1%8B%D0%B1%D1%80%D0%B0%D1%82%D1%8C%20%D0%BA%D0%B0%D1%80%D0%B0%D0%BD%D0%B4%D0%B0%D1%88%20%D0%B4%D0%BB%D1%8F%20%D1%80%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%20(%D0%BA%D0%B0%D0%BA%D0%B8%D0%B5%20%D0%BA%D0%B0%D1%80%D0%B0%D0%BD%D0%B4%D0%B0%D1%88%D0%B8%20%D0%BD%D1%83%D0%B6%D0%BD%D1%8B)..mp4?alt=media&token=871f16f9-982b-41a0-92b4-c2e4374c0201',
        },
        {
          "duration": 1073.0,
          "name": "Азбука Рисования 2",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%90%D0%B7%D0%B1%D1%83%D0%BA%D0%B0%20%D0%A0%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%2002%20%D0%9A%D0%B0%D0%BA%20%D1%80%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D1%82%D1%8C%20(%D0%BD%D0%B0%D1%80%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D1%82%D1%8C)%20%D0%B3%D0%BB%D0%B0%D0%B7%D0%B0%20%D0%BA%D0%B0%D1%80%D0%B0%D0%BD%D0%B4%D0%B0%D1%88%D0%BE%D0%BC%20-%20%D0%BE%D0%B1%D1%83%D1%87%D0%B0%D1%8E%D1%89%D0%B8%D0%B9%20%D1%83%D1%80%D0%BE%D0%BA%20(%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D1%8B%20%2B%20%D1%82%D0%B0%D0%BA%D0%BE%D0%B9%20%D0%B3%D0%BB%D0%B0%D0%B7)..mp4?alt=media&token=ae6225f2-7ee4-4958-9538-53f1013c3954',
        },
        {
          "duration": 313.0,
          "name": "Азбука Рисования 3",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%90%D0%B7%D0%B1%D1%83%D0%BA%D0%B0%20%D0%A0%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%2003%20%D0%9A%D0%B0%D0%BA%D1%83%D1%8E%20%D0%B1%D1%83%D0%BC%D0%B0%D0%B3%D1%83%20%D0%B2%D1%8B%D0%B1%D1%80%D0%B0%D1%82%D1%8C%20%D0%B4%D0%BB%D1%8F%20%D1%80%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F%20(%D0%B2%D0%B8%D0%B4%D1%8B%2C%20%D1%81%D0%B2%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%2C%20%D1%80%D0%B5%D0%BA%D0%BE%D0%BC%D0%B5%D0%BD%D0%B4%D0%B0%D1%86%D0%B8%D0%B8)..mp4?alt=media&token=3754359b-4a97-4a03-8ece-58074232fc57',
        },
      ],
    }).onError((e, _) => log("Error writing document: $e"));

    db.collection("courses").doc('1691378133').set({
      "name": "Бесплатный репетитор золотой плейлист",
      "author": "Bebris",
      "category": 'SWOGZvEvJJOJnOFtV7U2',
      "price": 120.0,
      "created": '2023-09-11T05:54:08.957Z',
      "duration": 100000.0, // (6+17+5)*60+41+53+13
      "about":
          'Английский язык с нуля. Бесплатный репетитор. Английский с нуля. Золотой плейлист. Полный курс. Уроки английского языка с нуля.',
      "openLesson": 1,
      "titleImage":
          'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/titles%2Flanguage.png?alt=media&token=362ff66d-5bbe-436b-bf18-e24f3be75e41',
      "lessons": [
        {
          "duration": 7.0,
          "name": "Английский язык с нуля. Lesson01",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%91%D0%95%D0%A1%D0%9F%D0%9B%D0%90%D0%A2%D0%9D%D0%AB%D0%99%20%D0%A0%D0%95%D0%9F%D0%95%D0%A2%D0%98%D0%A2%D0%9E%D0%A0%20%D0%97%D0%9E%D0%9B%D0%9E%D0%A2%D0%9E%D0%99%20%D0%9F%D0%9B%D0%95%D0%99%D0%9B%D0%98%D0%A1%D0%A2%20%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%98%D0%99%20%D0%AF%D0%97%D0%AB%D0%9A%20ELEMENTARY%20%D0%A3%D0%A0%D0%9E%D0%9A%203%20%D0%A3%D0%A0%D0%9E%D0%9A%D0%98%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%9E%D0%93%D0%9E%20%D0%AF%D0%97%D0%AB%D0%9A%D0%90.mp4?alt=media&token=0664ccaa-f88b-4798-a0b9-507b73be45b2',
        },
        {
          "duration": 7.0,
          "name": "Английский язык с нуля. Lesson02",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%91%D0%95%D0%A1%D0%9F%D0%9B%D0%90%D0%A2%D0%9D%D0%AB%D0%99%20%D0%A0%D0%95%D0%9F%D0%95%D0%A2%D0%98%D0%A2%D0%9E%D0%A0%20%D0%97%D0%9E%D0%9B%D0%9E%D0%A2%D0%9E%D0%99%20%D0%9F%D0%9B%D0%95%D0%99%D0%9B%D0%98%D0%A1%D0%A2%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%98%D0%99%20%D0%AF%D0%97%D0%AB%D0%9A%20ELEMENTARY%20%D0%A3%D0%A0%D0%9E%D0%9A%204%20%D0%A3%D0%A0%D0%9E%D0%9A%D0%98%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%9E%D0%93%D0%9E%20%D0%AF%D0%97%D0%AB%D0%9A%D0%90.mp4?alt=media&token=7e46a4c9-4db3-44ec-96fd-1a68596b23d3',
        },
        {
          "duration": 7.0,
          "name": "Английский язык с нуля. Lesson03",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%91%D0%95%D0%A1%D0%9F%D0%9B%D0%90%D0%A2%D0%9D%D0%AB%D0%99%20%D0%A0%D0%95%D0%9F%D0%95%D0%A2%D0%98%D0%A2%D0%9E%D0%A0%20%D0%97%D0%9E%D0%9B%D0%9E%D0%A2%D0%9E%D0%99%20%D0%9F%D0%9B%D0%95%D0%99%D0%9B%D0%98%D0%A1%D0%A2.%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%98%D0%99%20%D0%AF%D0%97%D0%AB%D0%9A%20ELEMENTARY%20%D0%A3%D0%A0%D0%9E%D0%9A%201%20%D0%A3%D0%A0%D0%9E%D0%9A%D0%98%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%9E%D0%93%D0%9E%20%D0%AF%D0%97%D0%AB%D0%9A%D0%90.mp4?alt=media&token=ada18950-3cd8-412f-8b42-c0f99eeca5a6',
        },
        {
          "duration": 7.0,
          "name": "Английский язык с нуля. Lesson04",
          "link":
              'https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%91%D0%95%D0%A1%D0%9F%D0%9B%D0%90%D0%A2%D0%9D%D0%AB%D0%99%20%D0%A0%D0%95%D0%9F%D0%95%D0%A2%D0%98%D0%A2%D0%9E%D0%A0%20%D0%97%D0%9E%D0%9B%D0%9E%D0%A2%D0%9E%D0%99%20%D0%9F%D0%9B%D0%95%D0%99%D0%9B%D0%98%D0%A1%D0%A2.%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%98%D0%99%20%D0%AF%D0%97%D0%AB%D0%9A%20ELEMENTARY%20%D0%A3%D0%A0%D0%9E%D0%9A%202%20%D0%A3%D0%A0%D0%9E%D0%9A%D0%98%20%D0%90%D0%9D%D0%93%D0%9B%D0%98%D0%99%D0%A1%D0%9A%D0%9E%D0%93%D0%9E%20%D0%AF%D0%97%D0%AB%D0%9A%D0%90.mp4?alt=media&token=914b5c69-1ccf-4cb9-b25c-fb1c59526b3c',
        },
      ],
    }).onError((e, _) => log("Error writing document: $e"));
*/

    // db
    //     .collection("courses")
    //     .doc('1691069119')
    //     .collection('lessons')
    //     .doc('1')
    //     .set({
    //   "link":
    //       "https://firebasestorage.googleapis.com/v0/b/onlinelearningapp-616fe.appspot.com/o/videos%2F%D0%9F%D0%BE%D0%B2%D0%BD%D0%B8%D0%B9%20%D0%BA%D1%83%D1%80%D1%81%20%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B8%20%D0%B2%20%D1%82%D0%B5%D1%81%D1%82%D0%B0%D1%85%20%D0%97%D0%B0%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8F%2021-26.%20%D0%97%D0%B0%D1%85%D0%B0%D1%80%D1%96%D0%B9%D1%87%D0%B5%D0%BD%D0%BA%D0%BE.mp4?alt=media&token=01473cf6-ac2b-436b-aef7-cbab0ec73dc7",
    // });
  }
}
