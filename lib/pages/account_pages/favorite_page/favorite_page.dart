import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/pages/account_pages/favorite_page/widgets/course_item.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/utils/extensions.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  static const routeName = '/account_pages/favorite_page';

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
        title: 'Favourite',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<CoursesBloc, CoursesState>(
                buildWhen: (p, c) {
                  return p.favoriteList != c.favoriteList;
                },
                builder: (context, stateCoursesBloc) {
                  userProgress =
                      context.read<ProgressBloc>().state.userProgress;
                  context.read<CoursesBloc>().add(
                        FilterUserCourses(
                          userProgress: userProgress,
                        ),
                      );

                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 5 / 6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: stateCoursesBloc.favoriteList.length,
                      itemBuilder: (context, index) {
                        int lessonCompleted = userProgress?[
                                    stateCoursesBloc.favoriteList[index].uid]!
                                .countCompletedLesson() ??
                            0;
                        return InkWell(
                          onTap: () {
                            if (stateCoursesBloc.favoriteList[index].uid !=
                                null) {
                              _goToOneCoursePage(
                                  uidCourse: stateCoursesBloc
                                      .favoriteList[index].uid!);
                            }
                          },
                          child: CourseItem(
                            courseModel: stateCoursesBloc.favoriteList[index],
                            backgroundColor: backgroundColorsList[index % 3],
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
