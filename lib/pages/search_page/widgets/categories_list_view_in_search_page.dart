import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/pages/search_page/widgets/categories_element_filter_item.dart';

class CategoriesListViewInSearchPage extends StatelessWidget {
  const CategoriesListViewInSearchPage({super.key});

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
