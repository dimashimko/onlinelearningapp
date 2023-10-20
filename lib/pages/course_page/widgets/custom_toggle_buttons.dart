import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/utils/enums.dart';

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