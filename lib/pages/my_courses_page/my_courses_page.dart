import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/elements/today_progress_widget.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({Key? key}) : super(key: key);

  static const routeName = '/my_courses_page/my_courses_page';

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

  void onTapCourse(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCoursesPageAppBar(onTap: () {
        _goToBackPage(context);
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TodayProgress(
                onTapMyCourses: null,
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return CourseItem(
                      onTapCourse: onTapCourse,
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

class CourseItem extends StatelessWidget {
  const CourseItem({
    required this.onTapCourse,
    super.key,
  });

  final VoidCallback onTapCourse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Product Design v1.0',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}

PreferredSizeWidget MyCoursesPageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: onTap,
    title: Text('My Courses'),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
