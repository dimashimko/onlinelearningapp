import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/utils/extensions.dart';

class TextLessonDurationWithCheckBox extends StatelessWidget {
  const TextLessonDurationWithCheckBox({
    required this.lesson,
    required this.lessonProgress,
    super.key,
  });

  final LessonModel lesson;
  final List<bool>? lessonProgress;

  @override
  Widget build(BuildContext context) {
    WatchStatus watchStatus = getWatchStatus(lessonProgress);
    return Row(
      children: [
        Text(
          Duration(
            seconds: lesson.duration?.toInt() ?? 0,
          ).formatToMinutes(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: getColorByWatchStatus(
              context,
              watchStatus,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        watchStatus == WatchStatus.notViewed
            ? const SizedBox()
            : watchStatus == WatchStatus.inProgress
            ? SvgPicture.asset(AppIcons.iconDoneOrange)
            : SvgPicture.asset(AppIcons.iconDoneBlue),
      ],
    );
  }
}

WatchStatus getWatchStatus(List<bool>? lessonProgress) {
  if (lessonProgress == null) {
    return WatchStatus.notViewed;
  }

  int counter = 0;
  for (var part in lessonProgress) {
    if (part) counter++;
  }
  if (counter == lessonProgress.length) {
    return WatchStatus.viewed;
  } else {
    return WatchStatus.inProgress;
  }
}

Color getColorByWatchStatus(BuildContext context, WatchStatus watchStatus) {
  Color resultColor = watchStatus == WatchStatus.notViewed
      ? Theme.of(context).colorScheme.outlineVariant
      : watchStatus == WatchStatus.inProgress
      ? colors(context).orange ?? Colors.orange
      : colors(context).blue ?? Colors.blue;
  return resultColor;
}
