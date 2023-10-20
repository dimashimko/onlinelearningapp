import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

class CategoriesListViewWidget extends StatelessWidget {
  const CategoriesListViewWidget({
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
