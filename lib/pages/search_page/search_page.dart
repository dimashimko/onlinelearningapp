import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/search_page/widgets/button_back.dart';
import 'package:online_learning_app/pages/search_page/widgets/categories_list_view_in_search_page.dart';
import 'package:online_learning_app/pages/search_page/widgets/courses_list_view_in_search_page.dart';
import 'package:online_learning_app/pages/search_page/widgets/custom_search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = '/search_pages/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ButtonBackSearchPage(
              goToBackPage: () => _goToBackPage(context),
            ),
            const SizedBox(height: 16.0),
            const CustomSearchTextField(),
            const CategoriesListViewInSearchPage(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Text(
                'Results',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            CoursesListViewInSearchPage(
              onTapCourse: (String uidCourse) {
                _goToOneCoursePage(uidCourse: uidCourse);
              },
            ),
          ],
        ),
      ),
    );
  }
}
