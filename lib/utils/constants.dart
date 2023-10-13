import 'package:flutter/material.dart';

enum BlocStatus { initial, loading, loaded, success, failed }

const Duration kAnimationDuration = Duration(milliseconds: 800);
const Curve kCurveAnimations = Curves.easeInBack;

const int pushActivityCoef = 100;
const int shiftDay = 0;
const int pushActivityUpdateInterval = 1;
//
class Constants {
  static const int PAGINATION_PAGE_SIZE = 5;
}

