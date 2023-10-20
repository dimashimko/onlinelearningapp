import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/widgets/elements/course_item.dart';

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
