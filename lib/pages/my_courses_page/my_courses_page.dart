import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/pages/my_courses_page/widget/no_produst_widget.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/utils/extensions.dart';
import 'package:online_learning_app/widgets/buttons/custom_play_button.dart';
import 'package:online_learning_app/widgets/elements/today_progress_widget.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({Key? key}) : super(key: key);

  static const routeName = '/my_courses_page/my_courses_page';

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  List<Color> colorsList = [];
  List<Color> backgroundColorsList = [];
  Map<String, CourseProgressModel>? userProgress;

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

  void _goToOneCoursePage({
    required String uidCourse,
  }) async {
    _navigateToPage(
      context: context,
      route: OneCoursePage.routeName,
      arguments: OneCoursePageArguments(
        uidCourse: uidCourse,
      ),
      isRoot: true,
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<ProgressBloc>().add(
          GetUserProgressEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    colorsList = [
      colors(context).red ?? Colors.red,
      colors(context).blue ?? Colors.red,
      colors(context).green ?? Colors.red,
    ];
    backgroundColorsList = [
      colors(context).redLight ?? Colors.red,
      colors(context).blueLight ?? Colors.red,
      colors(context).greenLight ?? Colors.red,
    ];
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: 'My Courses',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TodayProgress(
                onTapMyCourses: null,
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<CoursesBloc, CoursesState>(
                buildWhen: (p, c) {
                  return p.userCoursesList != c.userCoursesList;
                },
                builder: (context, stateCoursesBloc) {
                  userProgress =
                      context.read<ProgressBloc>().state.userProgress;
                  context.read<CoursesBloc>().add(
                        FilterUserCourses(
                          userProgress: userProgress,
                        ),
                      );
                  return stateCoursesBloc.userCoursesList.isEmpty
                      ? const NoProductWidget()
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 5 / 6,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: stateCoursesBloc.userCoursesList.length,
                            itemBuilder: (context, index) {
                              int lessonCompleted = userProgress?[
                                          stateCoursesBloc
                                              .userCoursesList[index].uid]
                                      ?.countCompletedLesson() ??
                                  0;
                              return InkWell(
                                onTap: () {
                                  if (stateCoursesBloc
                                          .userCoursesList[index].uid !=
                                      null) {
                                    _goToOneCoursePage(
                                        uidCourse: stateCoursesBloc
                                            .userCoursesList[index].uid!);
                                  }
                                },
                                child: CourseItem(
                                  courseModel:
                                      stateCoursesBloc.userCoursesList[index],
                                  backgroundColor:
                                      backgroundColorsList[index % 3],
                                  color: colorsList[index % 3],
                                  lessonCompleted: lessonCompleted,
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class CustomLinearGradientLine extends StatelessWidget {
  const CustomLinearGradientLine({
    required this.sec,
    super.key,
  });

  final int sec;

  @override
  Widget build(BuildContext context) {
    int minRounded = sec > 3600 ? 60 : sec ~/ 60;
    return Stack(
      children: [
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment(((minRounded * 2) / 60) - 1, 0.0),
              colors: <Color>[
                Theme.of(context).colorScheme.onSecondary,
                Theme.of(context).colorScheme.tertiaryContainer,
              ],
              tileMode: TileMode.decal,
            ),
          ),
        ),
      ],
    );
  }
}
