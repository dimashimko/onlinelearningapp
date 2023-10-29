import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

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

  CustomVideoPlayerController getCustomVideoPlayerController({
    required VideoPlayerController dataSourceController,
  }) {
    return CustomVideoPlayerController(
      context: context,
      videoPlayerController: dataSourceController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        playButton: SvgPicture.asset(
          AppIcons.playButton,
          height: 20,
          width: 20,
        ),
        pauseButton: SvgPicture.asset(
          AppIcons.pauseButton,
          height: 20,
          width: 20,
        ),
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

        // playButton: CustomVideoPlay
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _customVideoPlayerController.dispose();
    _videoController.dispose();
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
                alternativePhoto: AppImages.emptyCourse,
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
