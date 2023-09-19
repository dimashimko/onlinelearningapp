import 'package:flutter/material.dart';

enum BlocStatus { initial, loading, loaded, success, failed }

const Duration kAnimationDuration = Duration(milliseconds: 800);
const Curve kCurveAnimations = Curves.easeInBack;

const int pushActivityCoef = 1;
const int shiftDay = 0;
const int pushActivityUpdateInterval = 1;
