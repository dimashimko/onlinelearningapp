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
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/formatTime.dart';
import 'package:online_learning_app/utils/get_course_model_by_uid.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_star.dart';
import 'package:online_learning_app/widgets/buttons/custom_lock_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_pause_button_with_progress.dart';
import 'package:online_learning_app/widgets/buttons/custom_play_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_pause_button.dart';
import 'package:online_learning_app/widgets/elements/customImageViewer.dart';

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
    log('*** go to back page');
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
          ChangeCurrentCourseEvent(
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
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Stack(
                        children: [
                          CourseVideoPlayer(
                            currentCourse: currentCourse!,
                          ),
                          ButtonBack(
                            onTapButtonBack: () => _goToBackPage(context),
                          )
                        ],
                      ),
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

class ButtonBack extends StatelessWidget {
  const ButtonBack({
    required this.onTapButtonBack,
    super.key,
  });

  final VoidCallback onTapButtonBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapButtonBack(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(AppIcons.arrow_back),
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
  bool isPlaying = false;
  int currentProgress = 0;

  @override
  void dispose() {
    super.dispose();
    log('*** OneCoursePage dispose');
    dataSourceController.dispose();
  }

  // build UI of Player
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
      // if lesson has changed
      listenWhen: (p, c) {
        return p.currentLessonIndex != c.currentLessonIndex;
      },
      listener: (context, state) {
        // reload new video
        if (state.currentLessonIndex != null) {
          dataSourceController.pause();
          String? url =
              widget.currentCourse.lessons?[state.currentLessonIndex!].link;
          final uri = Uri.parse(url ?? '');
          dataSourceController = VideoPlayerController.networkUrl(uri)
            ..initialize().then((value) => setState(() {
                  _customVideoPlayerController = getCustomVideoPlayerController(
                    dataSourceController: dataSourceController,
                  );
                  dataSourceController.play();
                }));

          // add Listener
          dataSourceController.addListener(() {
            // push progress to Bloc. (each second)
            if (dataSourceController.value.position == dataSourceController.value.duration) {
              // The video has finished playing
              log('*** Video finished playing');
/*              context.read<VideoBloc>().add(
                ChangeProgressEvent(
                  newViewProgressInPercent: newViewProgressInPercent,
                  newProgressValue: dataSourceController.value.position.inMicroseconds/1000000,
                ),
              );*/
            }
            if (currentProgress !=
                dataSourceController.value.position.inSeconds) {
              currentProgress = dataSourceController.value.position.inSeconds;

              Duration currentPosition = dataSourceController.value.position;
              Duration totalDuration = dataSourceController.value.duration;
              double? newViewProgressInPercent = (currentPosition.inMilliseconds /
                      totalDuration.inMilliseconds) *
                  100;
              // log('*** newViewProgressInPercent $newViewProgressInPercent');
              context.read<VideoBloc>().add(
                    ChangeProgressEvent(
                      newViewProgressInPercent: newViewProgressInPercent,
                      newProgressValue: dataSourceController.value.position.inMicroseconds/1000000,
                    ),
                  );
            }

            // push Play/Pause status to Bloc
            if (dataSourceController.value.isPlaying != isPlaying) {
              isPlaying = dataSourceController.value.isPlaying;
              context.read<VideoBloc>().add(
                    ChangePlaybackStatusEvent(
                      // newPlaybackStatus: dataSourceController.value.isPlaying
                      newPlaybackStatus: isPlaying
                          ? PlaybackStatus.play
                          : PlaybackStatus.pause,
                    ),
                  );
            }
          });
        }
      },
      child: BlocListener<VideoBloc, VideoState>(
        // manipulate with controller when tap custom play/pause
        listenWhen: (p, c) {
          return p.playbackStatus != c.playbackStatus;
        },
        listener: (context, state) {
          if (state.playbackStatus == PlaybackStatus.pause) {
            if (dataSourceController.value.isPlaying) {
              _customVideoPlayerController.videoPlayerController.pause();
            }
          } else {
            _customVideoPlayerController.videoPlayerController.play();
          }
        },
        child: _customVideoPlayerController
                .videoPlayerController.dataSource.isEmpty
            ? CustomImageViewer(
                link: widget.currentCourse.title,
                alternativePhoto: AppImages.empty_title,
              )
            : dataSourceController.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: dataSourceController.value.aspectRatio,
                      child: CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ),
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
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BlocBuilder<VideoBloc, VideoState>(
                //   builder: (context, state) {
                //     return Text(
                //       state.currentLessonIndex.toString() ?? '',
                //       style: Theme.of(context)
                //           .textTheme
                //           .displayLarge
                //           ?.copyWith(fontSize: 20.0),
                //       overflow: TextOverflow.fade,
                //     );
                //   },
                // ),
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
                    openLesson: currentCourse.openLesson ?? 1000000,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 98.0,
          // width: double.infinity,
          // alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, -4), // Shadow position
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
        ),
      ],
    );
  }
}

class LessonList extends StatelessWidget {
  const LessonList({
    required this.lessons,
    required this.openLesson,
    super.key,
  });

  final List<LessonModel> lessons;
  final int openLesson;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 16.0),
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemCount: lessons.length,
      itemBuilder: (context, index) => LessonItem(
        lesson: lessons[index],
        index: index,
        openLesson: openLesson,
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  const LessonItem({
    required this.lesson,
    required this.index,
    required this.openLesson,
    super.key,
  });

  final LessonModel lesson;
  final int index;
  final int openLesson;

  void onTapPlay(BuildContext context) {
    context.read<VideoBloc>().add(
          ChangeCurrentLessonEvent(
            newCurrentLessonIndex: index,
          ),
        );
  }

  void onTapPause(BuildContext context) {
    context.read<VideoBloc>().add(
          const ChangePlaybackStatusEvent(
            newPlaybackStatus: PlaybackStatus.pause,
          ),
        );
  }

  void onTapResume(BuildContext context) {
    context.read<VideoBloc>().add(
          const ChangePlaybackStatusEvent(
            newPlaybackStatus: PlaybackStatus.play,
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
          BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              if (index < openLesson) {
                if (index == state.currentLessonIndex) {
                  if (state.playbackStatus == PlaybackStatus.pause) {
                    return CustomPlayButton(
                      onTap: () {
                        onTapResume(context);
                      },
                    );
                  } else {
                    return BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        return CustomPauseButtonWithProgress(
                          angle: state.currentProgressInPercent,
                          onTap: () {
                            onTapPause(context);
                          },
                        );
                      },
                    );
                  }
                } else {
                  return CustomPlayButton(
                    onTap: () {
                      onTapPlay(context);
                    },
                  );
                }
              } else {
                return CustomLockButton(
                  onTap: () {},
                );
              }
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
                isFullText ? AppIcons.arrow_up : AppIcons.arrow_down,
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
