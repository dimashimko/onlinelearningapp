import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/video_bloc/video_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/pages/one_course_pages/no_videos_page/no_videos_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/formatTime.dart';
import 'package:online_learning_app/utils/get_course_model_by_uid.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_star.dart';
import 'package:online_learning_app/widgets/buttons/custom_circle_button.dart';

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

  // late VideoPlayerController dataSourceController;
  // late CustomVideoPlayerController _customVideoPlayerController;

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
    context.read<VideoBloc>().add(
          ChangeCurrentCourse(
            uidCourse: widget.uidCourse,
          ),
        );
/*    String? url = currentCourse?.lessons?[0].link;
    // String? url = currentCourse?.title;
    // log('*** url: $url');
    final uri = Uri.parse(url ?? '');
    log('*** uri: $uri');

    dataSourceController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((value) => setState(() {}));
    dataSourceController.addListener(() {
      // log('*** event of videoPlayerController');
      // log('*** position ${videoPlayerController.value.position.inSeconds}');
      // log('*** videoPlayerOptions ${videoPlayerController.videoPlayerOptions}');
      // log('*** dataSource ${videoPlayerController.dataSource}');
    });

    _customVideoPlayerController = getCustomVideoPlayerController(
      dataSourceController: dataSourceController,
    );*/
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
                    child: CourseVideoPlayer(
                      currentCourse: currentCourse!,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: CoursePanel(
                      currentCourse: currentCourse!,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class CourseVideoPlayer extends StatefulWidget {
  const CourseVideoPlayer({
    required this.currentCourse,
    super.key,
  });

  final CourseModel currentCourse;

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  late VideoPlayerController dataSourceController =
      VideoPlayerController.networkUrl(Uri.parse(''));
  late CustomVideoPlayerController _customVideoPlayerController =
      CustomVideoPlayerController(
    context: context,
    videoPlayerController: dataSourceController,
  );

  @override
  void dispose() {
    super.dispose();
    log('*** OneCoursePage dispose');
    dataSourceController.dispose();
  }

  CustomVideoPlayerController getCustomVideoPlayerController({
    required VideoPlayerController dataSourceController,
  }) {
    return CustomVideoPlayerController(
      context: context,
      videoPlayerController: dataSourceController,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
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
    return BlocListener<VideoBloc, VideoState>(
      listenWhen: (p, c) {
        return p.currentLessonIndex != c.currentLessonIndex;
      },
      listener: (context, state) {
        if (state.currentLessonIndex != null) {
          dataSourceController.pause();
          String? url =
              widget.currentCourse.lessons?[state.currentLessonIndex!].link;
          final uri = Uri.parse(url ?? '');
          // log('*** uri: $uri');
          dataSourceController = VideoPlayerController.networkUrl(uri)
            ..initialize().then((value) => setState(() {
                  _customVideoPlayerController = getCustomVideoPlayerController(
                    dataSourceController: dataSourceController,
                  );
                }));
          dataSourceController.play();
        }
      },
      child: CustomVideoPlayer(
        customVideoPlayerController: _customVideoPlayerController,
      ),
    );
  }
}

class CoursePanel extends StatelessWidget {
  const CoursePanel({
    required this.currentCourse,
    super.key,
  });

  final CourseModel currentCourse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              return Text(
                state.currentLessonIndex.toString() ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 20.0),
                overflow: TextOverflow.fade,
              );
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  currentCourse.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 20.0),
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(
                '\$${currentCourse.price}' ?? '',
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
                seconds: currentCourse.duration?.toInt() ?? 0,
              ),
            )} · ${currentCourse.lessons?.length} Lessons',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          AboutCourse(
            description: currentCourse.about ?? '',
          ),
/*          Container(
            width: double.infinity,
            height: 150.0,
            color: Colors.black12,
          ),*/
          Expanded(
            child: LessonList(
              lessons: currentCourse.lessons ?? [],
            ),
          ),
          Container(
            height: 98.0,
            width: double.infinity,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: StarButton(
                      isEnable: false,
                      onTap: () {
                        log('*** ${DateTime.now().year}');
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: CustomButton(
                      title: 'Buy Now',
                      onTap: () {
                        log('*** ${DateTime.now().year}');
                      },
                    ),
                  ),
                ],
              ),
            ),
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
        index: index,
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  const LessonItem({
    required this.lesson,
    required this.index,
    super.key,
  });

  final LessonModel lesson;
  final int index;

  void onTapPlay(BuildContext context, int pos) {
    context.read<VideoBloc>().add(
          ChangeCurrentLesson(
            newCurrentLessonIndex: index,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            (index + 1).toString().padLeft(2, '0'),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 24.0),
          ),
          const SizedBox(width: 32.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.name ?? '',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  formatTimeToMinutes(
                    Duration(
                      seconds: lesson.duration?.toInt() ?? 0,
                    ),
                  ),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          CustomCircleButton(
            onTap: () {
              onTapPlay(context, index);
            },
          ),
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
