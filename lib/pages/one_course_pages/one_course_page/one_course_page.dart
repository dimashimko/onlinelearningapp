import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/helpers/get_course_model_by_uid_helper.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/pages/one_course_pages/no_videos_page/no_videos_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/statistic_alert_dialog.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/button_back.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/course_panel.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/course_video_player.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/lesson_item.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/payment_page.dart';

class OneCoursePageArguments {
  OneCoursePageArguments({
    required this.uidCourse,
  });

  final String uidCourse;
}

class OneCoursePage extends StatefulWidget {
  const OneCoursePage({
    required this.uidCourse,
    Key? key,
  }) : super(key: key);

  final String uidCourse;
  static const routeName = '/one_course_pages/one_course_page';

  @override
  State<OneCoursePage> createState() => _OneCoursePageState();
}

class _OneCoursePageState extends State<OneCoursePage> {
  CourseModel? currentCourse;

  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
    Object? arguments,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushNamed(route, arguments: arguments);
  }

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog();
      },
    );
  }

  void onTapFavoriteButton() {
    context.read<ProgressBloc>().add(
          TapButtonFavorite(),
        );
  }

  void onTapBuyButton({
    required double price,
  }) {
    _navigateToPage(
      context: context,
      route: PaymentPage.routeName,
      arguments: PaymentPageArguments(
        price: price,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentCourse = getCourseModelByUid(
      widget.uidCourse,
      context.read<CoursesBloc>().state.coursesList,
    );
    context.read<AnalyticsBloc>().add(
          OnCourseSelectedEvent(
            currentCourse: currentCourse,
          ),
        );

    context.read<ProgressBloc>().add(
          ChangeCurrentCourseEvent(
            uidCourse: widget.uidCourse,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return currentCourse == null
        ? const NoVideosPage()
        : Scaffold(
            body: SafeArea(
              child: BlocListener<ProgressBloc, ProgressState>(
                listenWhen: (p, c) {
                  return p.showStatisticTrigger != c.showStatisticTrigger;
                },
                listener: (context, state) {
                  context.read<NotificationBloc>().add(
                        AddNotificationCompletingFirstLessonEvent(),
                      );
                  showAlertDialog(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: CourseVideoPlayer(
                                currentCourse: currentCourse!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11.0,
                                vertical: 13.0,
                              ),
                              child: Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            ButtonBack(
                              onTapButtonBack: () => _goToBackPage(context),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: CoursePanel(
                        currentCourse: currentCourse!,
                        onTapFavoriteButton: onTapFavoriteButton,
                        onTapBuyButton: () {
                          onTapBuyButton(
                            price: currentCourse!.price ?? 0.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}




class LessonList extends StatelessWidget {
  const LessonList({
    required this.lessons,
    required this.openLesson,
    super.key,
  });

  final List<LessonModel> lessons;
  final int openLesson;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        CourseProgressModel? currentCourseProgressModel =
            state.userProgress?[state.currentCourseUid];
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20.0)
              .copyWith(bottom: 16.0),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemCount: lessons.length,
          itemBuilder: (context, index) => LessonItem(
            lesson: lessons[index],
            lessonProgress:
                currentCourseProgressModel?.lessonsProgress?['$index'],
            bought: currentCourseProgressModel?.bought ?? false,
            index: index,
            openLesson: openLesson,
          ),
        );
      },
    );
  }
}





