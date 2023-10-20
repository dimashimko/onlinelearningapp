import 'package:flutter/material.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/widgets/buttons/custom_play_button.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({
    required this.courseModel,
    required this.backgroundColor,
    required this.color,
    required this.lessonCompleted,
    super.key,
  });

  final CourseModel courseModel;
  final Color backgroundColor;
  final Color color;
  final int lessonCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseModel.name ?? '',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16.0,
                  ),
            ),
            const SizedBox(height: 20.0),
            Stack(
              children: [
                Container(
                  height: 6.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors(context).white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                Container(
                  height: 6.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment(
                          ((lessonCompleted * 2) /
                                  (courseModel.lessons?.length ?? 1)) -
                              1,
                          0.0),
                      colors: <Color>[
                        color.withAlpha(64),
                        color,
                      ],
                      tileMode: TileMode.decal,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Completed',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${lessonCompleted.toString()}/${courseModel.lessons?.length}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 20.0,
                      ),
                ),
                CustomPlayButton(
                  onTap: () {},
                  color: color,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
