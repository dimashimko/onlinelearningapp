import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/search_page/search_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';
import 'package:online_learning_app/widgets/elements/custom_search_text_field.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  static const routeName = '/course_pages/course_page';

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final _searchController = TextEditingController();

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

  void _goToSearchPage(BuildContext context) async {
    context.read<CoursesBloc>().add(
          ClearFilters(),
        );
    _navigateToPage(
      context: context,
      route: SearchPage.routeName,
      isRoot: true,
    );
  }

  void _goToSearchPageWithFilter(BuildContext context, String? category) async {
    context.read<CoursesBloc>().add(
          ClearFilters(),
        );
    context.read<CoursesBloc>().add(
          ChangeFilterCategory(
            add: category,
          ),
        );
    _navigateToPage(
      context: context,
      route: SearchPage.routeName,
      isRoot: true,
    );
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
    context.read<CoursesBloc>().add(GetAllCourses(orderBy: OrderBy.name.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 24.0,
                        ),
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
                    ),
                    CategoriesListView(
                      onTapCategory: (String? category) {
                        _goToSearchPageWithFilter(context, category);
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choice your course',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const CustomToggleButtons(),
                    const SizedBox(height: 16.0),
                    CoursesListView(
                      onTapCourse: (String uidCourse) {
                        _goToOneCoursePage(uidCourse: uidCourse);
                      },
                    ),
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
  const CustomToggleButtons({super.key});

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
          context
              .read<CoursesBloc>()
              .add(GetAllCourses(orderBy: OrderBy.name.name));
        }
        if (newCurrent == 1) {
          context
              .read<CoursesBloc>()
              .add(GetAllCourses(orderBy: OrderBy.duration.name));
        }
        if (newCurrent == 2) {
          context
              .read<CoursesBloc>()
              .add(GetAllCourses(orderBy: OrderBy.created.name));
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
  const CategoriesListView({
    required this.onTapCategory,
    super.key,
  });

  final Function(String?) onTapCategory;

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
                itemCount: state.categoryList.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        onTapCategory(state.categoryList[index].name);
                      },
                      child: SizedBox(
                        width: 240,
                        child: CustomImageViewer(
                          link: state.categoryList[index].categoryTitle,
                          alternativePhoto: AppImages.emptyCourse,
                        ),
                      ),
                    ));
          },
        ),
      ),
    );
  }
}

class CoursesListView extends StatelessWidget {
  const CoursesListView({
    required this.onTapCourse,
    super.key,
  });

  final Function(String) onTapCourse;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: state.coursesList.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (state.coursesList[index].uid != null) {
                  onTapCourse(state.coursesList[index].uid!);
                }
              },
              child: CourseItem(
                courseModel: state.coursesList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
