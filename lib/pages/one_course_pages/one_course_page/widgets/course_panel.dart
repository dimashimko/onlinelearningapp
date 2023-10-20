import 'package:flutter/material.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/about_course_widget.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/bottom_panel_buttons.dart';
import 'package:online_learning_app/utils/extensions.dart';

class CoursePanel extends StatelessWidget {
  const CoursePanel({
    required this.currentCourse,
    required this.onTapFavoriteButton,
    required this.onTapBuyButton,
    super.key,
  });

  final CourseModel currentCourse;
  final VoidCallback onTapFavoriteButton;
  final VoidCallback onTapBuyButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentCourse.name ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 20.0),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Text(
                      '\$${currentCourse.price.toString()}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 20.0),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${Duration(seconds: currentCourse.duration?.toInt() ?? 0).formatToHour()} '
                      '· ${currentCourse.lessons?.length} Lessons',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16.0),
                AboutCourseWidget(
                  description: currentCourse.about ?? '',
                ),
                Expanded(
                  child: LessonList(
                    lessons: currentCourse.lessons ?? [],
                    openLesson: currentCourse.openLesson ?? 1000000,
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomPanelButtons(
          onTapFavoriteButton: onTapFavoriteButton,
          onTapBuyButton: onTapBuyButton,
        ),
      ],
    );
  }
}
