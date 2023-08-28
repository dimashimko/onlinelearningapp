import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/time_converter.dart';
import 'package:online_learning_app/widgets/elements/customImageViewer.dart';

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

  void _goToSearchPage(BuildContext context) {
    log('*** _goToSearchPage');
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
/*                      InkWell(
                      child: TextField(
                        onTap: () {
                          log('tap1 tap1');
                        },
                      ),
                      onTap: () {
                        log('tap2 tap2');
                      },
                    ),*/
                    FindTextField(
                      searchController: _searchController,
                      onTapSetting: () => _goToSearchPage(context),
                      onTap: () => _goToSearchPage(context),
                      // isReadOnly: true,
                      isReadOnly: false,
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

class CategoryAdsModel {
  CategoryAdsModel({
    required this.categories,
    required this.image,
  });

  final Categories categories;
  final String image;
}

class CategoriesListView extends StatelessWidget {
  CategoriesListView({super.key});

  final List<CategoryAdsModel> categories = [
    CategoryAdsModel(
      categories: Categories.language,
      image: AppIcons.ads_language,
    ),
    CategoryAdsModel(
      categories: Categories.painting,
      image: AppIcons.ads_painting,
    ),
    CategoryAdsModel(
      categories: Categories.language,
      image: AppIcons.ads_language,
    ),
  ];

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
              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              // itemCount: categories.length,
              itemCount: state.categoryList.length,
              itemBuilder: (context, index) =>
                  SizedBox(
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

class CourseItem extends StatelessWidget {
  const CourseItem({
    required this.courseModel,
    super.key,
  });

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
        // color: Colors.black54,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: CustomImageViewer(
                link: courseModel.title,
                alternativePhoto: AppImages.empty_title,
              ),
            ),
            const SizedBox(width: 24.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseModel.name ?? 'null',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.human),
                      const SizedBox(width: 6.0),
                      Text(
                        courseModel.author ?? '---',
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$ ${courseModel.price.toString() ?? '---'}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(width: 6.0),
                      Container(
                        child: Text(
                          durationToString(
                            second: courseModel.duration ?? 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FindTextField extends StatefulWidget {
  const FindTextField({
    required this.searchController,
    required this.onTapSetting,
    required this.onTap,
    required this.isReadOnly,
    super.key,
  });

  final TextEditingController searchController;
  final VoidCallback onTapSetting;
  final VoidCallback onTap;
  final bool isReadOnly;

  @override
  State<FindTextField> createState() => _FindTextFieldState();
}

class _FindTextFieldState extends State<FindTextField> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(
        // color: Colors.red,
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
    return TextField(
      controller: widget.searchController,
      readOnly: widget.isReadOnly,
      onTap: () {
        widget.onTap();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.inverseSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            AppIcons.search_grey,
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.searchController.text.isNotEmpty)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: SvgPicture.asset(
                    AppIcons.clear_text,
                  ),
                ),
                onTap: () {
                  widget.searchController.text = '';
                },
              ),
            const SizedBox(width: 16.0),
            InkWell(
              splashColor: Colors.transparent,
              onTap: widget.onTapSetting,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: SvgPicture.asset(
                  AppIcons.filter,
                ),
              ),
            ),
          ],
        ),
        // errorMaxLines: 2,
        // border: InputBorder.none,
        border: customBorder,
        focusedBorder: customBorder,
        enabledBorder: customBorder,
        hintText: 'Find Cousre',
        hintStyle: Theme.of(context).textTheme.titleSmall,
        // suffixIcon: widget.suffixIcon,
        // suffixIconColor: AppColors.white,
        // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
