import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/video_model/lesson_model.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/widgets/text_lesson_duration_with_check_box.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/buttons/custom_lock_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_pause_button_with_progress.dart';
import 'package:online_learning_app/widgets/buttons/custom_play_button.dart';

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
