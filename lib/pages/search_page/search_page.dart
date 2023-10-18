import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';
import 'package:online_learning_app/widgets/elements/custom_search_text_field.dart';

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
            ButtonBack(
              goToBackPage: () => _goToBackPage(context),
            ),
            const SizedBox(height: 16.0),
            const CustomSearchTextField(),
            const CategoriesListView(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Text(
                'Results',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            CoursesListView(
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

class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({super.key});

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final _searchController = TextEditingController();

  void _onTapOpenFilterSetting(BuildContext context) {
    context.read<CoursesBloc>().add(
          FilterBottomSheetEnable(
            isFilterNavToSearchPage: false,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
          GetFilteredCourses(),
        );
    _searchController.addListener(() {
      context.read<CoursesBloc>().add(
            ChangeFilterText(newFilterText: _searchController.text),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursesBloc, CoursesState>(
      listenWhen: (p, c) {
        return p.filterText != c.filterText && c.filterText.isEmpty;
      },
      listener: (context, state) {
        _searchController.clear();
      },
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          bool isReadOnly =
              state.filterEnabledType == FilterEnabledType.price ||
                  state.filterEnabledType == FilterEnabledType.duration;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FindTextField(
              searchController: _searchController,
              onTapSetting: () => _onTapOpenFilterSetting(context),
              onTap: () {},
              isReadOnly: isReadOnly,
            ),
          );
        },
      ),
    );
  }
}

class ButtonBack extends StatelessWidget {
  const ButtonBack({
    required this.goToBackPage,
    super.key,
  });

  final VoidCallback goToBackPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          AppIcons.arrowBack,
        ),
      ),
      onTap: () => goToBackPage(),
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: state.filteredCoursesList.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (state.filteredCoursesList[index].uid != null) {
                  onTapCourse(state.filteredCoursesList[index].uid!);
                }
              },
              child: CourseItem(
                courseModel: state.filteredCoursesList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0).copyWith(left: 20.0),
      child: SizedBox(
        height: 36,
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8.0),
                itemCount: state.categoryList.length,
                itemBuilder: (context, index) => SizedBox(
                      child: CategoriesElementFilterItem(
                        name: state.categoryList[index].name ?? ' ',
                        isEnable: state.filterCategory
                            .contains(state.categoryList[index].name),
                      ),
                    ));
          },
        ),
      ),
    );
  }
}

class CategoriesElementFilterItem extends StatelessWidget {
  const CategoriesElementFilterItem({
    required this.name,
    required this.isEnable,
    super.key,
  });

  final String name;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isEnable
            ? context
                .read<CoursesBloc>()
                .add(ChangeFilterCategory(remove: name))
            : context.read<CoursesBloc>().add(ChangeFilterCategory(add: name));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnable
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceTint,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: isEnable
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
