import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/category/category_model.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/duration_range/duration_range.dart';

class MyFirestoreProgressService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // current state -> getFromFiresStore

  void newProgress({
    required String uidCourse,
    required int numLesson,
    required int timePoint,
  }) {

  }
}
