import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/pages/one_course_pages/no_videos_page/no_videos_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/statistic_alert_dialog.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/payment_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/utils/formatDataTime.dart';
import 'package:online_learning_app/utils/get_course_model_by_uid.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_star.dart';
import 'package:online_learning_app/widgets/buttons/custom_lock_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_pause_button_with_progress.dart';
import 'package:online_learning_app/widgets/buttons/custom_play_button.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

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

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog();
      },
    );
  }

  void onTapFavoriteButton() {
    context.read<ProgressBloc>().add(
          TapButtonFavorite(),
        );
  }

  void onTapBuyButton({
    required double price,
  }) {
    _navigateToPage(
      context: context,
      route: PaymentPage.routeName,
      arguments: PaymentPageArguments(
        price: price,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentCourse = getCourseModelByUid(
      widget.uidCourse,
      context.read<CoursesBloc>().state.coursesList,
    );
    context.read<AnalyticsBloc>().add(
          OnCourseSelectedEvent(
            currentCourse: currentCourse,
          ),
        );

    context.read<ProgressBloc>().add(
          ChangeCurrentCourseEvent(
            uidCourse: widget.uidCourse,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return currentCourse == null
        ? const NoVideosPage()
        : Scaffold(
            body: SafeArea(
              child: BlocListener<ProgressBloc, ProgressState>(
                listenWhen: (p, c) {
                  return p.showStatisticTrigger != c.showStatisticTrigger;
                },
                listener: (context, state) {
                  context.read<NotificationBloc>().add(
                        AddNotificationCompletingFirstLessonEvent(),
                      );
                  showAlertDialog(context);
                },
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
                            SizedBox(
                              width: double.infinity,
                              child: CourseVideoPlayer(
                                currentCourse: currentCourse!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11.0,
                                vertical: 13.0,
                              ),
                              child: Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
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
                        onTapFavoriteButton: onTapFavoriteButton,
                        onTapBuyButton: () {
                          onTapBuyButton(
                            price: currentCourse!.price ?? 0.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
        child: SvgPicture.asset(AppIcons.arrowBack),
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
  late VideoPlayerController _videoController =
      VideoPlayerController.networkUrl(Uri.parse(''));
  late CustomVideoPlayerController _customVideoPlayerController =
      CustomVideoPlayerController(
    context: context,
    videoPlayerController: _videoController,
  );
  bool isPlaying = false;
  int currentProgress = 0;

  @override
  void dispose() {
    super.dispose();

    _videoController.dispose();
  }

  CustomVideoPlayerController getCustomVideoPlayerController({
    required VideoPlayerController dataSourceController,
  }) {
    return CustomVideoPlayerController(
      context: context,
      videoPlayerController: dataSourceController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        enterFullscreenButton: SvgPicture.asset(
          AppIcons.fullScreen,
          height: 20,
          width: 20,
        ),
        exitFullscreenButton: SvgPicture.asset(
          AppIcons.normalScreen,
          height: 20,
          width: 20,
        ),
        customVideoPlayerProgressBarSettings:
            CustomVideoPlayerProgressBarSettings(
          progressColor: colors(context).orange ?? Colors.orange,
          progressBarHeight: 3,
        ),
        settingsButtonAvailable: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgressBloc, ProgressState>(
      listenWhen: (p, c) {
        return p.currentLessonIndex != c.currentLessonIndex;
      },
      listener: (context, state) {
        if (state.currentLessonIndex != null) {
          _videoController.pause();
          String? url =
              widget.currentCourse.lessons?[state.currentLessonIndex!].link;
          final uri = Uri.parse(url ?? '');
          _videoController = VideoPlayerController.networkUrl(uri)
            ..initialize().then(
              (value) => setState(
                () {
                  _customVideoPlayerController = getCustomVideoPlayerController(
                    dataSourceController: _videoController,
                  );
                  _videoController.play();
                },
              ),
            );

          _videoController.addListener(() {
            if (!_videoController.value.isPlaying &&
                _videoController.value.isInitialized &&
                _videoController.value.position ==
                    _videoController.value.duration) {
              context.read<ProgressBloc>().add(
                    VideoFinishEvent(),
                  );
            }
            if (currentProgress != _videoController.value.position.inSeconds) {
              currentProgress = _videoController.value.position.inSeconds;

              Duration currentPosition = _videoController.value.position;
              Duration totalDuration = _videoController.value.duration;
              double? newViewProgressInPercent =
                  (currentPosition.inMilliseconds /
                          totalDuration.inMilliseconds) *
                      100;

              context.read<ProgressBloc>().add(
                    ChangeProgressEvent(
                      newViewProgressInPercent: newViewProgressInPercent,
                      newProgressValue:
                          _videoController.value.position.inMicroseconds /
                              1000000,
                    ),
                  );
            }

            if (_videoController.value.isPlaying != isPlaying) {
              isPlaying = _videoController.value.isPlaying;
              context.read<ProgressBloc>().add(
                    ChangePlaybackStatusEvent(
                      newPlaybackStatus: isPlaying
                          ? PlaybackStatus.play
                          : PlaybackStatus.pause,
                    ),
                  );
            }
          });
        }
      },
      child: BlocListener<ProgressBloc, ProgressState>(
        listenWhen: (p, c) {
          return p.playbackStatus != c.playbackStatus;
        },
        listener: (context, state) {
          if (state.playbackStatus == PlaybackStatus.pause) {
            if (_videoController.value.isPlaying) {
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
                alternativePhoto: AppImages.empty_course,
              )
            : _videoController.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
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
    required this.onTapFavoriteButton,
    required this.onTapBuyButton,
    super.key,
  });

  final CourseModel currentCourse;
  final VoidCallback onTapFavoriteButton;
  final VoidCallback onTapBuyButton;

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
                      '\$${currentCourse.price.toString()}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 20.0),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${formatDurationToHour(
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
        BottomPanelButtons(
          onTapFavoriteButton: onTapFavoriteButton,
          onTapBuyButton: onTapBuyButton,
        ),
      ],
    );
  }
}

class BottomPanelButtons extends StatelessWidget {
  const BottomPanelButtons({
    required this.onTapFavoriteButton,
    required this.onTapBuyButton,
    super.key,
  });

  final VoidCallback onTapFavoriteButton;
  final VoidCallback onTapBuyButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.0,
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, state) {
            CourseProgressModel? currentCourseProgressModel =
                state.userProgress?[state.currentCourseUid];

            return Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: StarButton(
                    isEnable: (currentCourseProgressModel?.favorites) ?? false,
                    onTap: () {
                      onTapFavoriteButton();
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: (currentCourseProgressModel?.bought ?? false)
                      ? const CustomButtonLight(
                          title: 'Bought ✓ ',
                          onTap: null,
                        )
                      : CustomButton(
                          title: 'Buy Now',
                          onTap: () {
                            onTapBuyButton();
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
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
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        CourseProgressModel? currentCourseProgressModel =
            state.userProgress?[state.currentCourseUid];
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20.0)
              .copyWith(bottom: 16.0),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemCount: lessons.length,
          itemBuilder: (context, index) => LessonItem(
            lesson: lessons[index],
            lessonProgress:
                currentCourseProgressModel?.lessonsProgress?['$index'],
            bought: currentCourseProgressModel?.bought ?? false,
            index: index,
            openLesson: openLesson,
          ),
        );
      },
    );
  }
}

class LessonItem extends StatelessWidget {
  const LessonItem({
    required this.lesson,
    required this.lessonProgress,
    required this.bought,
    required this.index,
    required this.openLesson,
    super.key,
  });

  final LessonModel lesson;
  final List<bool>? lessonProgress;
  final bool bought;
  final int index;
  final int openLesson;

  void onTapPlay(BuildContext context) {
    context.read<ProgressBloc>().add(
          ChangeCurrentLessonEvent(
            newCurrentLessonIndex: index,
          ),
        );
  }

  void onTapPause(BuildContext context) {
    context.read<ProgressBloc>().add(
          const ChangePlaybackStatusEvent(
            newPlaybackStatus: PlaybackStatus.pause,
          ),
        );
  }

  void onTapResume(BuildContext context) {
    context.read<ProgressBloc>().add(
          const ChangePlaybackStatusEvent(
            newPlaybackStatus: PlaybackStatus.play,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          (index + 1).toString().padLeft(2, '0'),
          style:
              Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 24.0),
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
              TextLessonDurationWithCheckBox(
                lesson: lesson,
                lessonProgress: lessonProgress,
              ),
            ],
          ),
        ),
        BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, state) {
            if (index < openLesson || bought) {
              if (index == state.currentLessonIndex) {
                if (state.playbackStatus == PlaybackStatus.pause) {
                  return CustomPlayButton(
                    onTap: () {
                      onTapResume(context);
                    },
                  );
                } else {
                  return CustomPauseButtonWithProgress(
                    angle: state.currentProgressInPercent,
                    onTap: () {
                      onTapPause(context);
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
    );
  }
}

class TextLessonDurationWithCheckBox extends StatelessWidget {
  const TextLessonDurationWithCheckBox({
    required this.lesson,
    required this.lessonProgress,
    super.key,
  });

  final LessonModel lesson;
  final List<bool>? lessonProgress;

  @override
  Widget build(BuildContext context) {
    WatchStatus watchStatus = getWatchStatus(lessonProgress);
    return Row(
      children: [
        Text(
          formatDurationToMinutes(
            Duration(
              seconds: lesson.duration?.toInt() ?? 0,
            ),
          ),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: getColorByWatchStatus(
                  context,
                  watchStatus,
                ),
              ),
        ),
        const SizedBox(width: 8.0),
        watchStatus == WatchStatus.notViewed
            ? const SizedBox()
            : watchStatus == WatchStatus.inProgress
                ? SvgPicture.asset(AppIcons.iconDoneOrange)
                : SvgPicture.asset(AppIcons.iconDoneBlue),
      ],
    );
  }
}

enum WatchStatus { notViewed, inProgress, viewed }

WatchStatus getWatchStatus(List<bool>? lessonProgress) {
  if (lessonProgress == null) {
    return WatchStatus.notViewed;
  }

  int counter = 0;
  for (var part in lessonProgress) {
    if (part) counter++;
  }
  if (counter == lessonProgress.length) {
    return WatchStatus.viewed;
  } else {
    return WatchStatus.inProgress;
  }
}

Color getColorByWatchStatus(BuildContext context, WatchStatus watchStatus) {
  Color resultColor = watchStatus == WatchStatus.notViewed
      ? Theme.of(context).colorScheme.outlineVariant
      : watchStatus == WatchStatus.inProgress
          ? colors(context).orange ?? Colors.orange
          : colors(context).blue ?? Colors.blue;
  return resultColor;
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
                isFullText ? AppIcons.arrowUp : AppIcons.arrowDown,
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
