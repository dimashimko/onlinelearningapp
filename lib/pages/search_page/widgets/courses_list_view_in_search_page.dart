import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';

class CoursesListViewInSearchPage extends StatelessWidget {
  const CoursesListViewInSearchPage({
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
