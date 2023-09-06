import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/pages/search_page/search_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/time_converter.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';
import 'package:online_learning_app/widgets/elements/customImageViewer.dart';
import 'package:online_learning_app/widgets/elements/custom_search_text_field.dart';

class CoursePage extends StatefulWidget {
  CoursePage({Key? key}) : super(key: key);

  static const routeName = '/course_pages/course_page';

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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

/*  void _goToSearchPage(BuildContext context) {
    log('*** _goToSearchPage');
  }*/

  void _goToSearchPage(BuildContext context) async {
    // log('*** _goToSearchPage');
    context.read<CoursesBloc>().add(
          ClearFilters(),
        );
    _navigateToPage(
      context: context,
      route: SearchPage.routeName,
      isRoot: true,
      // isRoot: false,
    );
  }

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(GetAllCourses(orderBy: 'name'));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   for (CourseModel course in context.read<CoursesBloc>().state.coursesList) {
  //     precacheImage(NetworkImage(course.title ?? ''), context);
  //     log('*** course.title: ${course.title ?? ''}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Course',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SvgPicture.asset(AppIcons.avatar),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FindTextField(
                      searchController: _searchController,
                      onTapSetting: () => _goToSearchPage(context),
                      onTap: () => _goToSearchPage(context),
                      isReadOnly: true,
                      // isReadOnly: false,
                    ),
                    CategoriesListView(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choice your course',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
/*                    CustomButton(
                      title: 'GetAllCourses',
                      onTap: () {
                        context.read<CoursesBloc>().add(GetAllCourses());
                      },
                    ),*/
                    const SizedBox(height: 8.0),
                    CustomToggleButtons(),
                    const SizedBox(height: 16.0),
                    CoursesListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomToggleButtons extends StatefulWidget {
  CustomToggleButtons({super.key});

  @override
  State<CustomToggleButtons> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  int _current = 0;
  List<String> modes = ['   All   ', 'Duration', 'New'];

  void onTapItem(int newCurrent) {
    setState(() {
      if (_current != newCurrent) {
        if (newCurrent == 0) {
          context.read<CoursesBloc>().add(GetAllCourses(orderBy: 'name'));
        }
        if (newCurrent == 1) {
          context.read<CoursesBloc>().add(GetAllCourses(orderBy: 'duration'));
          // context.read<CoursesBloc>().add(GetAllCoursesSortDuration());
        }
        if (newCurrent == 2) {
          context.read<CoursesBloc>().add(GetAllCourses(orderBy: 'created'));
        }
      }
      _current = newCurrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 24.0),
        itemCount: modes.length,
        itemBuilder: (context, index) => InkWell(
          splashColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: index == _current
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                modes[index],
                style: index == _current
                    ? Theme.of(context).textTheme.bodySmall
                    : Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          onTap: () {
            onTapItem(index);
          },
        ),
      ),
    );
  }
}

class CategoriesListView extends StatelessWidget {
  CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: SizedBox(
        height: 120,
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8.0),
                // itemCount: categories.length,
                itemCount: state.categoryList.length,
                itemBuilder: (context, index) => SizedBox(
                      width: 240,
                      child: CustomImageViewer(
                        link: state.categoryList[index].categoryTitle,
                        alternativePhoto: AppImages.empty_title,
                      ),
                    )
                // SvgPicture.asset(state.categoryList[index].categoryTitle),
                );
          },
        ),
      ),
    );
  }
}

class CoursesListView extends StatelessWidget {
  CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: state.coursesList.length,
            itemBuilder: (context, index) => CourseItem(
              courseModel: state.coursesList[index],
            ),
          );
        },
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
