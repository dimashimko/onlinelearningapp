import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range_model/duration_range_model.dart';

class MyFirestoreCourseService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<CourseModel>> getFilteredCoursesList({
    required List<String> uidsSelectedCategories,
    required double minPrice,
    required double maxPrice,
    required List<DurationRangeModel> filterDurationItems,
    required String searchKey,
    required FilterEnabledType filterEnabledType,
  }) async {
    List<CourseModel> listOfCoursesModel = [];
    Query<Map<String, dynamic>> filteredCourses = db.collection('courses');

    if (filterEnabledType == FilterEnabledType.text) {
      if (true) {
        filteredCourses = filteredCourses
            .orderBy(OrderBy.name.name)
            .startAt([searchKey]).endAt(['$searchKey\uf8ff']);
      }
    }

    if (true) {
      if (uidsSelectedCategories.isNotEmpty) {
        filteredCourses = filteredCourses.where(
          'category',
          whereIn: uidsSelectedCategories,
        );
      }
    }

    if (filterEnabledType == FilterEnabledType.price) {
      filteredCourses = filteredCourses.where('price', isGreaterThan: minPrice);
      filteredCourses =
          filteredCourses.where('price', isLessThan: maxPrice + 0.5);
    }

    if (filterEnabledType == FilterEnabledType.duration) {
      for (DurationRangeModel durationFilter in filterDurationItems) {
        if (durationFilter.isEnable) {
          filteredCourses = filteredCourses
              .where(
                OrderBy.duration.name,
                isGreaterThan: durationFilter.min * 3600,
              )
              .orderBy(OrderBy.duration.name);
          filteredCourses = filteredCourses.where(
            OrderBy.duration.name,
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

    return listOfCoursesModel;
  }

  Future<List<CourseModel>> getAllCoursesList(String orderBy) async {
    List<CourseModel> listOfCoursesModel = [];
    Query<Map<String, dynamic>> coursesCollection =
        db.collection('courses').orderBy(orderBy);

    await coursesCollection.get().then(
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
    db.collection("ads").doc().set({"uidCourse": "1691069119", "position": 1});
  }
}
