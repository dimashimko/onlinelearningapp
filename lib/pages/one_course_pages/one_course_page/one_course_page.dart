import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/pages/one_course_pages/no_videos_page/no_videos_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/formatTime.dart';
import 'package:online_learning_app/utils/get_course_model_by_uid.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class OneCoursePageArguments {
  OneCoursePageArguments({
    required this.uidCourse,
  });

  final String uidCourse;
}

class OneCoursePage extends StatefulWidget {
  const OneCoursePage({
    required this.uidCourse,
    Key? key,
  }) : super(key: key);

  final String uidCourse;
  static const routeName = '/one_course_pages/one_course_page';

  @override
  State<OneCoursePage> createState() => _OneCoursePageState();
}

class _OneCoursePageState extends State<OneCoursePage> {
  CourseModel? currentCourse;
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

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

  @override
  void initState() {
    super.initState();
    currentCourse = getCourseModelByUid(
      widget.uidCourse,
      context.read<CoursesBloc>().state.coursesList,
    );
    String? url = currentCourse?.lessons?[0].link;
    // String? url = currentCourse?.title;
    // log('*** url: $url');
    final uri = Uri.parse(url ?? '');
    log('*** uri: $uri');

    videoPlayerController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((value) => setState(() {}));
    videoPlayerController.addListener(() {
      log('*** event of videoPlayerController');
      log('*** position ${videoPlayerController.value.position.inSeconds}');
    });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        // settingsButton: SizedBox(),
        // showPlayButton: false,
        showPlayButton: true,
        settingsButtonAvailable: false,
        alwaysShowThumbnailOnVideoPaused: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentCourse == null
        ? const NoVideosPage()
        : Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: CoursePanel(
                      courseModel: currentCourse!,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class CoursePanel extends StatelessWidget {
  const CoursePanel({
    required this.courseModel,
    super.key,
  });

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  courseModel.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 20.0),
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(
                '\$${courseModel.price}' ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 20.0),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            '${formatTimeToHour(
              Duration(
                seconds: courseModel.duration ?? 0,
              ),
            )} · ${courseModel.lessons?.length} Lessons',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          AboutCourse(
            description: courseModel.about ?? '',
          ),
          Container(
            width: double.infinity,
            height: 150.0,
            color: Colors.black12,
          ),
          Expanded(
            child: LessonList(
              lessons: courseModel.lessons ?? [],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Buy Now',
                  onTap: () {
                    log('*** ${DateTime.now().year}');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LessonList extends StatelessWidget {
  const LessonList({
    required this.lessons,
    super.key,
  });

  final List<LessonModel> lessons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemCount: lessons.length,
      itemBuilder: (context, index) => LessonItem(
        lesson: lessons[index],
        pos: index,
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  const LessonItem({
    required this.lesson,
    required this.pos,
    super.key,
  });

  final LessonModel lesson;
  final int pos;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            (pos + 1).toString().padLeft(2, '0'),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 24.0),
          ),
          SizedBox(width: 32.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.name ?? '',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              SizedBox(height: 6.0),
              Text(
                '${formatTimeToMinutes(Duration(seconds: lesson.duration ?? 0))}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AboutCourse extends StatefulWidget {
  const AboutCourse({
    required this.description,
    super.key,
  });

  final String description;

  @override
  State<AboutCourse> createState() => _AboutCourseState();
}

class _AboutCourseState extends State<AboutCourse> {
  bool isFullText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'About this course',
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          widget.description,
          maxLines: isFullText ? 100 : 1,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              isFullText ? AppIcons.arrow_up : AppIcons.arrow_down,
            ),
          ),
          onTap: () {
            setState(() {
              isFullText = !isFullText;
            });
          },
        )
      ],
    );
  }
}
