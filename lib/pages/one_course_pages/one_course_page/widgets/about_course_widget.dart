import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class AboutCourseWidget extends StatefulWidget {
  const AboutCourseWidget({
    required this.description,
    super.key,
  });

  final String description;

  @override
  State<AboutCourseWidget> createState() => _AboutCourseWidgetState();
}

class _AboutCourseWidgetState extends State<AboutCourseWidget> {
  bool isFullText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this course',
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4.0),
        Text(
          widget.description,
          maxLines: isFullText ? 100 : 1,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Center(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                isFullText ? AppIcons.arrowUp : AppIcons.arrowDown,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                isFullText = !isFullText;
              });
            },
          ),
        ),
        const SizedBox(
          width: double.infinity,
        ),
      ],
    );
  }
}