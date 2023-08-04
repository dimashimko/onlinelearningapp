import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({Key? key}) : super(key: key);

  static const routeName = '/course_pages/course_page';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: CoursePageAppBar(onTap: () {
        _goToBackPage(context);
      }),*/
/*      appBar: CoursePageAppBar2(onTap: () {
        _goToBackPage(context);
      }),*/
      appBar: AppBar(
        title: Text(
          'Course',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('CoursePage'),
                Placeholder(),
                SvgPicture.asset(AppIcons.rectangle),
                SvgPicture.asset(AppIcons.rectangle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*PreferredSizeWidget CoursePageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: Text(
      'Course',
      style: Theme.of(context).textTheme.displaySmall,
    ),
    // onLeading: (){},
    title: const Text('CoursePage'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}*/
