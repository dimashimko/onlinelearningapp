import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/extensions.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

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
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
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
                alternativePhoto: AppImages.emptyCourse,
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
                        '\$ ${courseModel.price ?? '---'}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(width: 6.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            (courseModel.duration?.toInt() ?? 0)
                                .toTimeDurationString(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
/*                          child: Text(
                            formatSecondsToTimeDuration(
                              second: courseModel.duration?.toInt() ?? 0,
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,

                          ),*/
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
