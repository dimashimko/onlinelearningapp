import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/elements/custom_search_text_field.dart';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
