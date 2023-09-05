import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';
import 'package:online_learning_app/widgets/elements/custom_search_text_field.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  static const routeName = '/search_pages/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

  final _searchController = TextEditingController();

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
      // log('*** _searchController text ${_searchController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: SearchPageAppBar(onTap: () {
        _goToBackPage(context);
      }),*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SvgPicture.asset(
                    AppIcons.arrow_back,
                  ),
                ),
                onTap: (){
                  _goToBackPage(context);

                },
              ),
              FindTextField(
                searchController: _searchController,
                onTapSetting: () {
                  log('*** FilterBottomSheetEnable');
                  context.read<CoursesBloc>().add(FilterBottomSheetEnable());
                },
                onTap: () {
                  context.read<CoursesBloc>().add(FilterBottomSheetDisable());
                  log('*** onTap FindTextField');
                },
                // isReadOnly: true,
                isReadOnly: false,
              ),
              CategoriesListView(),
              Text(
                'Results',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              CoursesListView(),
            ],
          ),
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
            itemCount: state.filteredCoursesList.length,
            itemBuilder: (context, index) => CourseItem(
              courseModel: state.filteredCoursesList[index],
            ),
          );
        },
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
        height: 36,
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8.0),
                // itemCount: categories.length,
                itemCount: state.categoryList.length,
                itemBuilder: (context, index) => SizedBox(
                      // width: 240,
                      child: CategoriesElementFilterItem(
                        name: state.categoryList[index].name ?? ' ',
                        isEnable: state.categoryFilter
                            .contains(state.categoryList[index].name),
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
                .add(ChangeCategoryFilter(remove: name))
            : context.read<CoursesBloc>().add(ChangeCategoryFilter(add: name));
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
            // : Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget SearchPageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: onTap,
    title: Text(''),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
